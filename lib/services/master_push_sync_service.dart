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

  /// 🟢 main.dart کے لیے آٹو پش لسنر
  Future<void> initAutoPushListener() async {
    await _ensureBoxesOpened();

    for (String boxName in _targetBoxes) {
      final box = Hive.box(boxName);
      final sub = box.watch().listen((event) {
        if (event.value is Map) {
          final data = Map<String, dynamic>.from(event.value as Map);
          if (data['isSynced'] == false) {
            pushUnsyncedData(_activeCustomerPhone);
          }
        }
      });
      _hiveSubscriptions.add(sub);
    }
    debugPrint('🚀 [MasterPush] آٹو پش لسنر کامیابی سے ایکٹیو ہو گیا ہے۔');
  }

  /// 🟢 لوکل ہائیو میں موجود غیر سنک شدہ اینٹریز (isSynced == false) اپلوڈ کرنا
  Future<void> pushUnsyncedData([String? activePhone]) async {
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

      if (totalCount > 0) {
        await batch.commit();

        for (var update in pendingHiveUpdates) {
          final box = Hive.box(update['boxName'] as String);
          await box.put(update['key'], update['data']);
        }
        debugPrint('🎉 [MasterPush] $totalCount لوکل اینٹریز فائر اسٹور پر اپلوڈ ہو کر Synced ہو گئی ہیں۔');
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