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
  bool isPullingActive = false;

  String _activeCustomerPhone = '';
  final List<StreamSubscription> _hiveSubs = [];
  Timer? _debounceTimer;

  static const List<String> _globalBoxes = ['appConfigBox', 'stockBox', 'usersBox'];
  static const List<String> _targetedBoxes = ['customerBox', 'guarantorBox', 'packageBox', 'transactionBox', 'mediaBox'];

  bool get isPushing => _isPushing;

  Future<void> initAutoPushListener([String? activePhone]) async {
    if (activePhone != null && activePhone.trim().isNotEmpty) {
      _activeCustomerPhone = activePhone.trim().replaceAll(RegExp(r'[^0-9]'), '');
    }

    await stopAutoPushListener();

    final List<String> boxesToWatch = [
      ..._globalBoxes,
      if (_activeCustomerPhone.isNotEmpty) ..._targetedBoxes,
    ];

    for (String boxName in boxesToWatch) {
      if (Hive.isBoxOpen(boxName)) {
        final sub = Hive.box(boxName).watch().listen((_) => _schedulePush());
        _hiveSubs.add(sub);
      }
    }
    debugPrint('🚀 [MasterPush] پش لسنرز فعال ہو گئے۔');
  }

  void _schedulePush() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      if (!isPullingActive && !_isPushing) {
        pushUnsyncedData(_activeCustomerPhone);
      }
    });
  }

  Future<void> stopAutoPushListener() async {
    _debounceTimer?.cancel();
    for (var sub in _hiveSubs) {
      await sub.cancel();
    }
    _hiveSubs.clear();
  }

  /// 📤 صرف ان اینٹریز کو پش کرنا جن کی `isSynced == false` ہے (Write Batching کے ساتھ)
  Future<bool> pushUnsyncedData([String? activePhone]) async {
    if (_isPushing) {
      debugPrint('⏳ [MasterPush] پش پہلے سے جاری ہے۔');
      return false;
    }
    _isPushing = true;

    try {
      if (activePhone != null && activePhone.trim().isNotEmpty) {
        _activeCustomerPhone = activePhone.trim().replaceAll(RegExp(r'[^0-9]'), '');
      }

      final List<String> activeBoxesToPush = [
        ..._globalBoxes,
        if (_activeCustomerPhone.isNotEmpty) ..._targetedBoxes,
      ];

      final List<Map<String, dynamic>> itemsToPush = [];

      for (String boxName in activeBoxesToPush) {
        if (!Hive.isBoxOpen(boxName)) continue;

        final box = Hive.box(boxName);
        for (var key in box.keys) {
          final rawData = box.get(key);
          if (rawData is Map) {
            final mapData = Map<String, dynamic>.from(rawData);
            
            // 🎯 صرف اور صرف وہ اینٹری پش ہوگی جس کی isSynced == false ہو
            if (mapData['isSynced'] == false) {
              final resolvedDocId = (mapData['docId'] ?? mapData['id'] ?? mapData['transactionId'] ?? key).toString();

              itemsToPush.add({
                'boxName': boxName,
                'key': key,
                'docId': resolvedDocId,
                'data': mapData,
              });
            }
          }
        }
      }

      if (itemsToPush.isEmpty) {
        debugPrint('✅ [MasterPush] تمام ڈیٹا (isSynced == false) پہلے سے اپ ٹو ڈیٹ ہے۔');
        return true;
      }

      debugPrint('📤 [MasterPush] ${itemsToPush.length} اینٹریز فائر اسٹور پر بھیجی جا رہی ہیں...');

      // 💥 Write Batching: ۳۰۰ اینٹریز فی بیچ
      const chunkSize = 300;
      for (var i = 0; i < itemsToPush.length; i += chunkSize) {
        final chunk = itemsToPush.sublist(
          i, i + chunkSize > itemsToPush.length ? itemsToPush.length : i + chunkSize,
        );

        final batch = _firestore.batch();
        for (var item in chunk) {
          final data = Map<String, dynamic>.from(item['data']);
          data['isSynced'] = true; // فائر اسٹور پر جانے والے ڈیٹا میں isSynced = true ہوگا
          data['docId'] = item['docId'];

          final docRef = _firestore.collection(item['boxName']).doc(item['docId']);
          batch.set(docRef, data, SetOptions(merge: true));
        }

        // ۶ سیکنڈ ٹائم آؤٹ تا کہ ہینگ یا بلاک نہ ہو
        await batch.commit().timeout(const Duration(seconds: 6));

        // لوکل ہائیو میں isSynced = true اپ ڈیٹ کریں
        for (var item in chunk) {
          final box = Hive.box(item['boxName']);
          final updatedData = Map<String, dynamic>.from(item['data']);
          updatedData['isSynced'] = true;
          updatedData['docId'] = item['docId'];
          await box.put(item['key'], updatedData);
        }
      }

      debugPrint('🎉 [MasterPush] تمام غیر سنک شدہ اینٹریز فائر اسٹور پر کامیابی سے پش ہو گئیں۔');
      return true;
    } catch (e) {
      debugPrint('❌ [MasterPush Error]: $e');
      return false;
    } finally {
      _isPushing = false;
    }
  }
}