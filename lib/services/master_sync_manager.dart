import 'dart:io';
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

  /// 🕒 UI کے لیے فارمیٹ شدہ آخری سنک کا وقت حاصل کرنا
  String getLastSyncedFormatted() {
    try {
      if (!Hive.isBoxOpen('settingsBox')) return 'سنک نہیں ہوا';
      final box = Hive.box('settingsBox');
      final timeStr = box.get('lastSyncedTime');
      if (timeStr == null || timeStr.toString().isEmpty) return 'سنک نہیں ہوا';

      final dt = DateTime.parse(timeStr.toString()).toLocal();
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      final minute = dt.minute.toString().padLeft(2, '0');
      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');

      return '$day/$month/${dt.year} $hour:$minute $period';
    } catch (_) {
      return 'سنک نہیں ہوا';
    }
  }

  /// 🚀 ایپ اسٹارٹ گلوبل سنک (لاگ ان سے پہلے: صرف appConfig, stock, users, settings)
  Future<void> initGlobalSync() async {
    await _pullService.initPullService();
  }

  /// 🚀 لاگ ان آٹو سنک (لاگ ان کے بعد: کسٹمر کے تمام ٹارگٹڈ باکسز کھولنا، پش اور پل شروع کرنا)
  Future<void> startAutoSync(String activePhone) async {
    final cleanPhone = activePhone.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.isEmpty) return;

    await _pullService.startMasterLiveSync(cleanPhone);
    await _pushService.initAutoPushListener(cleanPhone);
    await _pushService.pushUnsyncedData(cleanPhone);
    await _updateLastSyncedTime();
  }

  /// 🔘 دستی سچا سنک بٹن (ہینگ فری، نیٹ ورک چیک اور بیچ پش کے ساتھ)
  Future<bool> runFullSync(String activePhone) async {
    if (_isSyncing) {
      debugPrint('⏳ [SyncManager] سنک کا عمل پہلے سے جاری ہے۔');
      return false;
    }

    _isSyncing = true;
    try {
      final hasNet = await _hasInternet();
      if (!hasNet) {
        debugPrint('⚠️ [SyncManager] انٹرنیٹ کنکشن دستیاب نہیں ہے۔');
        return false;
      }

      // ۱۔ لوکل غیر سنک شدہ (isSynced == false) ڈیٹا سرور پر پش کرنا (Write Batching)
      final pushOk = await _pushService.pushUnsyncedData(activePhone);

      // ۲۔ لائیو لسنرز اور کیشے کو دوبارہ تازہ کرنا
      await _pullService.startMasterLiveSync(activePhone);

      // ۳۔ آخری سنک کا وقت اپ ڈیٹ کرنا
      await _updateLastSyncedTime();

      debugPrint('✅ [SyncManager] مکمل سنک کامیاب رہا۔');
      return pushOk;
    } catch (e) {
      debugPrint('❌ [SyncManager Error]: $e');
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _updateLastSyncedTime() async {
    try {
      if (!Hive.isBoxOpen('settingsBox')) {
        await Hive.openBox('settingsBox');
      }
      await Hive.box('settingsBox').put('lastSyncedTime', DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('⚠️ [SettingsBox Error]: $e');
    }
  }

  /// 🛑 لاگ آؤٹ پر تمام ٹارگٹڈ لسنرز روکنا اور گلوبل حالت پر واپس جانا
  Future<void> stopAllSync() async {
    await _pushService.stopAutoPushListener();
    await _pullService.stopLiveSync();
    await _pullService.initPullService();
  }

  /// 🛡️ محفوظ انٹرنیٹ چیک (۳ سیکنڈ ٹائم آؤٹ کے ساتھ تا کہ UI ہینگ نہ ہو)
  Future<bool> _hasInternet() async {
    try {
      final res = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 3));
      return res.isNotEmpty && res[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}