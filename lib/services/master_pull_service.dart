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
  ];

  Future<void> initPullService() async {
    await _ensureBoxesOpened();
  }

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
          if (MasterPushSyncService().isPushing) return;

          MasterPushSyncService().isPullingActive = true;

          final Set<String> firestoreIds = snap.docs.map((doc) => doc.id.toString()).toSet();

          for (var doc in snap.docs) {
            final data = doc.data();
            await hiveBox.put(doc.id.toString(), _reorderFields(data));
          }

          // فائر اسٹور سے حذف شدہ ڈیٹا کا لوکل ہائیو سے خاتمہ
          final localKeys = hiveBox.keys.map((k) => k.toString()).toList();
          for (var localKey in localKeys) {
            if (!firestoreIds.contains(localKey)) {
              await hiveBox.delete(localKey);
            }
          }

          MasterPushSyncService().isPullingActive = false;
        });
        _firestoreSubscriptions.add(sub);
      } else if (boxName == 'transactionBox') {
        // ۲۔ transactionBox: customerId فیلڈ کے ساتھ ٹریکنگ
        final sub = _firestore
            .collection(boxName)
            .where('customerId', isEqualTo: cleanPhone)
            .snapshots()
            .listen((snap) async {
          if (MasterPushSyncService().isPushing) return;

          MasterPushSyncService().isPullingActive = true;

          final Set<String> firestoreDocIds = snap.docs.map((doc) => doc.id.toString()).toSet();

          for (var doc in snap.docs) {
            final data = doc.data();
            await hiveBox.put(doc.id.toString(), _reorderFields(data));
          }

          final localKeys = hiveBox.keys.toList();
          for (var key in localKeys) {
            final String stringKey = key.toString();
            final item = hiveBox.get(key);

            if (item is Map) {
              final p = (item['customerPhone'] ?? item['customerId'] ?? '').toString().trim();
              if (p == cleanPhone && !firestoreDocIds.contains(stringKey)) {
                await hiveBox.delete(key);
              }
            }
          }

          MasterPushSyncService().isPullingActive = false;
        });
        _firestoreSubscriptions.add(sub);
      } else {
        // ۳۔ باقی تمام باکسز: Document ID ہی کسٹمر کا فون نمبر ہے
        final sub = _firestore.collection(boxName).doc(cleanPhone).snapshots().listen((docSnap) async {
          if (MasterPushSyncService().isPushing) return;

          MasterPushSyncService().isPullingActive = true;

          if (docSnap.exists && docSnap.data() != null) {
            final data = docSnap.data()!;
            await hiveBox.put(cleanPhone, _reorderFields(data));
          } else {
            await hiveBox.delete(cleanPhone);
          }

          MasterPushSyncService().isPullingActive = false;
        });
        _firestoreSubscriptions.add(sub);
      }
    }
    debugPrint('🔥 [MasterPull] فائر اسٹور کا ریئل ٹائم لائیو لسنر چالو ہو گیا ہے۔');
  }

  Future<void> stopLiveSync() async {
    for (var sub in _firestoreSubscriptions) {
      await sub.cancel();
    }
    _firestoreSubscriptions.clear();
  }

  Map<String, dynamic> _reorderFields(Map<String, dynamic> rawData) {
    final Map<String, dynamic> orderedMap = {};
    rawData.forEach((key, value) {
      if (key != 'status' && key != 'isSynced' && key != 'timestamp') {
        orderedMap[key] = value;
      }
    });

    if (rawData.containsKey('status')) orderedMap['status'] = rawData['status'];
    orderedMap['isSynced'] = rawData['isSynced'] ?? true;
    if (rawData.containsKey('timestamp')) orderedMap['timestamp'] = rawData['timestamp'];

    return orderedMap;
  }

  Future<void> _ensureBoxesOpened() async {
    for (final name in _targetBoxes) {
      if (!Hive.isBoxOpen(name)) await Hive.openBox(name);
    }
    if (!Hive.isBoxOpen('settingsBox')) await Hive.openBox('settingsBox');
  }
}