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
  final List<StreamSubscription> _firestoreSubscriptions = [];

  static const List<String> _targetBoxes = [
    'customerBox',
    'guarantorBox',
    'packageBox',
    'usersBox',
    'transactionBox',
    'stockBox',
    'mediaBox', // 👈 mediaBox شامل کر دیا گیا
  ];

  Future<void> initPullService() async => await _ensureBoxesOpened();

  /// 🟢 فائر اسٹور سے لائیو لسنرز (Snapshots) ایکٹیو کرنا
  Future<void> startMasterLiveSync(String activePhone) async {
    final cleanPhone = activePhone.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.isEmpty) return;

    await _ensureBoxesOpened();
    await stopLiveSync();

    for (String boxName in _targetBoxes) {
      final hiveBox = Hive.box(boxName);

      if (boxName == 'stockBox') {
        // ۱۔ stockBox: تمام ڈاکومنٹس
        final sub = _firestore.collection(boxName).snapshots().listen((snap) async {
          await _processSnapshot(
            onProcess: () async {
              final firestoreIds = snap.docs.map((doc) => doc.id).toSet();

              for (var doc in snap.docs) {
                if (doc.exists) {
                  final preparedData = _prepareData(doc.id, doc.data());
                  await hiveBox.put(doc.id, preparedData);
                }
              }

              // حذف شدہ اسٹاک ہائیو سے صاف کرنا
              final localKeys = hiveBox.keys.map((k) => k.toString()).toList();
              for (var key in localKeys) {
                if (!firestoreIds.contains(key)) await hiveBox.delete(key);
              }
            },
            errorTag: 'Stock Pull',
          );
        });
        _firestoreSubscriptions.add(sub);
      } else if (boxName == 'transactionBox' || boxName == 'mediaBox') {
        // ۲۔ transactionBox اور mediaBox: customerId فیلڈ کے ساتھ فلٹرنگ
        final sub = _firestore
            .collection(boxName)
            .where('customerId', isEqualTo: cleanPhone)
            .snapshots()
            .listen((snap) async {
          await _processSnapshot(
            onProcess: () async {
              final firestoreDocIds = snap.docs.map((doc) => doc.id).toSet();

              for (var doc in snap.docs) {
                if (doc.exists) {
                  final preparedData = _prepareData(doc.id, doc.data());
                  await hiveBox.put(doc.id, preparedData);
                }
              }

              // حذف شدہ ریکارڈز ہائیو سے صاف کرنا
              final localKeys = hiveBox.keys.toList();
              for (var key in localKeys) {
                final item = hiveBox.get(key);
                if (item is Map) {
                  final p = (item['customerId'] ?? item['customerPhone'] ?? '').toString().trim();
                  if (p == cleanPhone && !firestoreDocIds.contains(key.toString())) {
                    await hiveBox.delete(key);
                  }
                }
              }
            },
            errorTag: '$boxName Pull',
          );
        });
        _firestoreSubscriptions.add(sub);
      } else {
        // ۳۔ باقی تمام باکسز: Document ID ہی کسٹمر فون نمبر ہے
        final sub = _firestore.collection(boxName).doc(cleanPhone).snapshots().listen((docSnap) async {
          await _processSnapshot(
            onProcess: () async {
              if (docSnap.exists && docSnap.data() != null) {
                final preparedData = _prepareData(docSnap.id, docSnap.data()!);
                await hiveBox.put(cleanPhone, preparedData);
              } else {
                await hiveBox.delete(cleanPhone);
              }
            },
            errorTag: '$boxName Pull',
          );
        });
        _firestoreSubscriptions.add(sub);
      }
    }
    debugPrint('🔥 [MasterPull] فائر اسٹور کا ریئل ٹائم لائیو لسنر چالو ہو گیا ہے۔');
  }

  /// 🎯 Wrapper logic for Pull execution and Mutex Lock
  Future<void> _processSnapshot({required Future<void> Function() onProcess, required String errorTag}) async {
    if (MasterPushSyncService().isPushing) return;
    MasterPushSyncService().isPullingActive = true;

    try {
      await onProcess();
    } catch (e) {
      debugPrint('❌ [$errorTag Error]: $e');
    } finally {
      MasterPushSyncService().isPullingActive = false;
    }
  }

  /// 🎯 ڈیٹا کو سنبھالنے، صاف کرنے اور ترتیب دینے کا واحد ہلکا پھلکا فنکشن
  Map<String, dynamic> _prepareData(String docId, Map<String, dynamic> raw) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(raw);

    // ۱۔ docId کی سیٹنگ
    data['docId'] = data['docId'] ?? docId;

    // ۲۔ Timestamps کا علاج (ISO String conversion)
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
    } else if (data['createdAt'] == null) {
      data['createdAt'] = DateTime.now().toIso8601String();
    }

    if (data['timestamp'] is Timestamp) {
      data['timestamp'] = (data['timestamp'] as Timestamp).toDate().toIso8601String();
    }

    // ۳۔ فیلڈز کی درست ترتیب (Reordering Logic)
    final Map<String, dynamic> orderedMap = {};
    data.forEach((key, value) {
      if (key != 'status' && key != 'isSynced' && key != 'timestamp') {
        orderedMap[key] = value;
      }
    });

    orderedMap['status'] = data['status'] ?? 'pending';
    orderedMap['isSynced'] = data['isSynced'] ?? true;
    if (data.containsKey('timestamp')) orderedMap['timestamp'] = data['timestamp'];

    return orderedMap;
  }

  Future<void> stopLiveSync() async {
    for (var sub in _firestoreSubscriptions) {
      await sub.cancel();
    }
    _firestoreSubscriptions.clear();
  }

  Future<void> _ensureBoxesOpened() async {
    for (final name in _targetBoxes) {
      if (!Hive.isBoxOpen(name)) await Hive.openBox(name);
    }
    if (!Hive.isBoxOpen('settingsBox')) await Hive.openBox('settingsBox');
  }
}