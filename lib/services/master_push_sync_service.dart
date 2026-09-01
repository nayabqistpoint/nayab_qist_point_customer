import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MasterPushSyncService {
  static final MasterPushSyncService _instance = MasterPushSyncService._internal();
  factory MasterPushSyncService() => _instance;
  MasterPushSyncService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isPushing = false;
  
  /// 🛑 Mutex Flag: جب Pull چالو ہو تو Push خاموش رہے گی
  bool isPullingActive = false; 

  String _activeCustomerPhone = '';
  final List<StreamSubscription> _hiveSubscriptions = [];

  static const List<String> _targetBoxes = [
    'customerBox',
    'guarantorBox',
    'packageBox',
    'usersBox',
    'transactionBox',
    'stockBox',
  ];

  bool get isPushing => _isPushing;

  /// 🟢 main.dart / SyncManager کے لیے آٹو پش لسنر
  Future<void> initAutoPushListener([String? activePhone]) async {
    if (activePhone != null && activePhone.trim().isNotEmpty) {
      _activeCustomerPhone = activePhone.trim().replaceAll(RegExp(r'[^0-9]'), '');
    }

    await _ensureBoxesOpened();
    await stopAutoPushListener();

    for (String boxName in _targetBoxes) {
      final box = Hive.box(boxName);
      final sub = box.watch().listen((event) {
        // اگر Pull چالو ہے تو Push ٹرگر نہ کریں
        if (isPullingActive || _isPushing) return;

        if (event.value is Map) {
          final data = Map<String, dynamic>.from(event.value as Map);
          if (data['isSynced'] == false) {
            pushUnsyncedData(_activeCustomerPhone);
          }
        }
      });
      _hiveSubscriptions.add(sub);
    }
    debugPrint('🚀 [MasterPush] ریئل ٹائم ہائیو لسنر ایکٹیو ہو گیا ہے۔');
  }

  Future<void> stopAutoPushListener() async {
    for (var sub in _hiveSubscriptions) {
      await sub.cancel();
    }
    _hiveSubscriptions.clear();
  }

  /// 🟢 لوکل ہائیو کی غیر سنک شدہ اینٹریز (isSynced == false) کو WriteBatch سے اپلوڈ کرنا
  Future<void> pushUnsyncedData([String? activePhone]) async {
    if (isPullingActive) return; // Pull چالو ہو تو پش روکا جائے گا

    if (activePhone != null && activePhone.trim().isNotEmpty) {
      _activeCustomerPhone = activePhone.trim().replaceAll(RegExp(r'[^0-9]'), '');
    }

    if (_isPushing) return;
    _isPushing = true;

    try {
      await _ensureBoxesOpened();
      final WriteBatch batch = _firestore.batch();
      final List<Map<String, dynamic>> pendingHiveUpdates = [];
      int totalCount = 0;

      for (String boxName in _targetBoxes) {
        final box = Hive.box(boxName);

        for (var key in box.keys) {
          final rawData = box.get(key);
          if (rawData is! Map) continue;

          final data = Map<String, dynamic>.from(rawData);

          if (data['isSynced'] == false) {
            final Map<String, dynamic> firestoreData = Map<String, dynamic>.from(data);
            firestoreData['isSynced'] = true;

            final String docId = key.toString();
            final DocumentReference docRef = _firestore.collection(boxName).doc(docId);

            batch.set(docRef, firestoreData, SetOptions(merge: true));

            pendingHiveUpdates.add({
              'boxName': boxName,
              'key': key,
              'data': firestoreData,
            });

            totalCount++;
          }
        }
      }

      // 🎯 Atomic WriteBatch Commitment
      if (totalCount > 0) {
        await batch.commit();

        // کامیابی کے بعد Hive میں isSynced = true لکھتے وقت لسنر کو گارڈ کریں
        for (var update in pendingHiveUpdates) {
          final box = Hive.box(update['boxName'] as String);
          await box.put(update['key'], update['data']);
        }

        debugPrint('🎉 [MasterPush] $totalCount اینٹریز WriteBatch کے ذریعے فائر اسٹور پر پش ہو گئیں۔');
      }
    } catch (e) {
      debugPrint('❌ [MasterPush Error]: $e');
    } finally {
      _isPushing = false;
    }
  }

  Future<void> _ensureBoxesOpened() async {
    for (final name in _targetBoxes) {
      if (!Hive.isBoxOpen(name)) await Hive.openBox(name);
    }
    if (!Hive.isBoxOpen('settingsBox')) await Hive.openBox('settingsBox');
  }
}