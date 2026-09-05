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
    'mediaBox',
    'appConfigBox', // 👈 appConfigBox شامل کر دیا گیا
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

      // 🟢 ۱۔ appConfigBox: گلوبل/اوپن لسنر (تمام ڈاکومنٹس بغیر فون نمبر کے)
      if (boxName == 'appConfigBox') {
        final sub = _firestore.collection(boxName).snapshots().listen((snap) async {
          await _processSnapshot(
            onProcess: () async {
              for (var doc in snap.docs) {
                if (doc.exists) {
                  final preparedData = _prepareData(doc.id, doc.data());
                  await hiveBox.put(doc.id, preparedData);
                }
              }
            },
            errorTag: 'AppConfig Pull',
          );
        });
        _firestoreSubscriptions.add(sub);
      }
      // ۲۔ stockBox: تمام ڈاکومنٹس
      else if (boxName == 'stockBox') {
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

  Map<String, dynamic> _prepareData(String docId, Map<String, dynamic> raw) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(raw);
    data['docId'] = data['docId'] ?? docId;

    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
    } else if (data['createdAt'] == null) {
      data['createdAt'] = DateTime.now().toIso8601String();
    }

    if (data['timestamp'] is Timestamp) {
      data['timestamp'] = (data['timestamp'] as Timestamp).toDate().toIso8601String();
    }

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