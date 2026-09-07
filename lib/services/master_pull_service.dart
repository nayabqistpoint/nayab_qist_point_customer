import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'master_push_sync_service.dart';

class MasterLiveSyncService {
  static final MasterLiveSyncService _instance = MasterLiveSyncService._internal();
  factory MasterLiveSyncService() => _instance;
  MasterLiveSyncService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<StreamSubscription> _globalSubs = [];
  final List<StreamSubscription> _targetedSubs = [];

  static const List<String> _globalBoxes = [
    'appConfigBox',
    'stockBox',
    'usersBox',
    'settingsBox',
  ];

  static const List<String> _targetedBoxes = [
    'customerBox',
    'guarantorBox',
    'packageBox',
    'transactionBox',
    'mediaBox',
  ];

  /// 🟢 ۱۔ ایپ اسٹارٹ: صرف گلوبل باکسز کھولنا اور لائیو سنک کرنا (لاگ ان سے پہلے)
  Future<void> initPullService() async {
    await _ensureBoxes(_globalBoxes);
    _stopSubs(_globalSubs);

    for (final boxName in ['appConfigBox', 'stockBox', 'usersBox']) {
      await _hydrateBox(boxName, _firestore.collection(boxName));
      
      final sub = _firestore.collection(boxName).snapshots().listen((snap) {
        _handleQuerySnap(boxName, snap);
      }, onError: (e) => debugPrint('❌ [$boxName Stream Error]: $e'));
      
      _globalSubs.add(sub);
    }
  }

  /// 🟢 ۲۔ لاگ ان کے بعد: کسٹمر کے مخصوص ٹارگٹڈ باکسز کھولنا اور لائیو سنک کرنا
  Future<void> startMasterLiveSync(String activePhone) async {
    final cleanPhone = activePhone.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.isEmpty) return;

    await _ensureBoxes(_targetedBoxes);
    _stopSubs(_targetedSubs);

    // ۱۔ ٹرانزیکشن اور میڈیا کلیکشنز (customerId کے مطابق)
    for (final boxName in ['transactionBox', 'mediaBox']) {
      final query = _firestore.collection(boxName).where('customerId', isEqualTo: cleanPhone);
      await _hydrateBox(boxName, query);

      final sub = query.snapshots().listen((snap) {
        _handleQuerySnap(boxName, snap);
      }, onError: (e) => debugPrint('❌ [$boxName Stream Error]: $e'));
      _targetedSubs.add(sub);
    }

    // ۲۔ کسٹمر، گارنٹر، پیکج (Single Documents by cleanPhone)
    for (final boxName in ['customerBox', 'guarantorBox', 'packageBox']) {
      final docRef = _firestore.collection(boxName).doc(cleanPhone);
      
      try {
        final docSnap = await docRef.get().timeout(const Duration(seconds: 4));
        if (docSnap.exists && docSnap.data() != null) {
          await Hive.box(boxName).put(cleanPhone, _prepareData(docSnap.id, docSnap.data()!));
        }
      } catch (e) {
        debugPrint('⚠️ [$boxName Doc Hydrate Skip]: $e');
      }

      final sub = docRef.snapshots().listen((docSnap) {
        _processSnapshot(() async {
          final box = Hive.box(boxName);
          if (docSnap.exists && docSnap.data() != null) {
            await box.put(cleanPhone, _prepareData(docSnap.id, docSnap.data()!));
          } else if (!docSnap.exists && !docSnap.metadata.isFromCache) {
            await box.delete(cleanPhone);
          }
        }, '$boxName Doc');
      }, onError: (e) => debugPrint('❌ [$boxName Doc Error]: $e'));
      _targetedSubs.add(sub);
    }
  }

  /// 🔄 سرور سے ڈیٹا لا کر ہائیو باکس بھرنے کا محفوظ فنکشن (آف لائن ہونے پر کیشے محفوظ رہے گا)
  Future<void> _hydrateBox(String boxName, Query query) async {
    try {
      final snap = await query.get().timeout(const Duration(seconds: 4));
      final box = Hive.box(boxName);
      for (var doc in snap.docs) {
        if (doc.exists && doc.data() != null) {
          await box.put(doc.id, _prepareData(doc.id, doc.data() as Map<String, dynamic>));
        }
      }
    } catch (e) {
      debugPrint('⚠️ [$boxName Hydration Warning]: $e');
    }
  }

  /// 📡 Query Snapshots کو ہینڈل کرنے والا لسنر
  void _handleQuerySnap(String boxName, QuerySnapshot snap) {
    _processSnapshot(() async {
      final box = Hive.box(boxName);
      final isFromCache = snap.metadata.isFromCache;

      for (var change in snap.docChanges) {
        final doc = change.doc;
        if (change.type == DocumentChangeType.removed) {
          if (!isFromCache) await box.delete(doc.id);
        } else if (doc.exists && doc.data() != null) {
          await box.put(doc.id, _prepareData(doc.id, doc.data() as Map<String, dynamic>));
        }
      }
    }, '$boxName Stream');
  }

  /// 🛡️ پش/پل ٹکراؤ سے بچاؤ کی سیف گارڈر لاجک
  void _processSnapshot(Future<void> Function() onProcess, String tag) async {
    if (MasterPushSyncService().isPushing) return;
    
    MasterPushSyncService().isPullingActive = true;
    try {
      await onProcess();
    } catch (e) {
      debugPrint('❌ [$tag Error]: $e');
    } finally {
      MasterPushSyncService().isPullingActive = false;
    }
  }

  Map<String, dynamic> _prepareData(String docId, Map<String, dynamic> raw) {
    final data = _cleanTimestamps(raw) as Map<String, dynamic>;
    data['docId'] ??= docId;
    data['createdAt'] ??= DateTime.now().toIso8601String();
    data['status'] ??= 'approved';
    data['isSynced'] = true; // سرور سے آیا ہوا ڈیٹا ہمیشہ isSynced: true ہوگا
    return data;
  }

  dynamic _cleanTimestamps(dynamic val) {
    if (val is Timestamp) return val.toDate().toIso8601String();
    if (val is Map) return val.map((k, v) => MapEntry(k.toString(), _cleanTimestamps(v)));
    if (val is List) return val.map((v) => _cleanTimestamps(v)).toList();
    return val;
  }

  void _stopSubs(List<StreamSubscription> subs) {
    for (var sub in subs) {
      sub.cancel();
    }
    subs.clear();
  }

  Future<void> stopLiveSync() async {
    _stopSubs(_targetedSubs);
    _stopSubs(_globalSubs);
  }

  Future<void> _ensureBoxes(List<String> boxes) async {
    for (final name in boxes) {
      if (!Hive.isBoxOpen(name)) await Hive.openBox(name);
    }
  }
}