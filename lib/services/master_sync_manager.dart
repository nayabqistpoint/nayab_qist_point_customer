import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'master_pull_service.dart';
import 'master_push_sync_service.dart';

class MasterSyncManager {
  static final MasterSyncManager _instance = MasterSyncManager._internal();
  factory MasterSyncManager() => _instance;
  MasterSyncManager._internal();

  final MasterLiveSyncService _pullService = MasterLiveSyncService();
  final MasterPushSyncService _pushService = MasterPushSyncService();

  bool _isSyncing = false;

  /// 🚀 ایپ کے آن ہوتے ہی گلوبل باکسز (stockBox, usersBox, appConfigBox) کو سنک کرنا
  Future<void> initGlobalSync() async {
    // یہ صرف گلوبل باکسز کو انیشلائز کرے گا
    await _pullService.initPullService();
  }

  /// 🚀 لاگ ان ہوتے ہی کسٹمر کے ٹارگٹڈ باکسز کے لیے آٹو سنک شروع کرنا
  Future<void> startAutoSync(String activePhone) async {
    final cleanPhone = activePhone.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.isEmpty) return;

    // ۱۔ لائیو لسنرز (Pull) چالو کریں
    await _pullService.startMasterLiveSync(cleanPhone);

    // ۲۔ ہائیو باکس کے لسنرز (Push) چالو کریں
    await _pushService.initAutoPushListener(cleanPhone);

    // ۳۔ غیر سنک شدہ اینٹریز پش کریں
    await _pushService.pushUnsyncedData(cleanPhone);
  }

  /// 🔘 دستی سنک بٹن
  Future<void> runFullSync(String activePhone) async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      await _pushService.pushUnsyncedData(activePhone);
      await _pullService.startMasterLiveSync(activePhone);

      if (!Hive.isBoxOpen('settingsBox')) {
        await Hive.openBox('settingsBox');
      }
      await Hive.box('settingsBox').put('lastSyncedTime', DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('❌ [MasterSyncManager Error]: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// 🛑 لاگ آؤٹ پر تمام لسنرز بند کرنا
  Future<void> stopAllSync() async {
    await _pushService.stopAutoPushListener();
    await _pullService.stopLiveSync();
  }
}