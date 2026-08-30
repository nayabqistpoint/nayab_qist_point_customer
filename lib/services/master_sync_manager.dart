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

  /// پش اور پل دونوں کو ایک ساتھ چلانے کا ماسٹر فنکشن
  Future<void> runFullSync(String activePhone) async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      // ۱۔ لوکل غیر سنک شدہ ڈیٹا اپلوڈ کریں
      await _pushService.pushUnsyncedData(activePhone);

      // ۲۔ فائر اسٹور سے سارا ڈیٹا ٹیلی اور ڈاؤن لوڈ کریں
      await _pullService.onUserLoggedIn(activePhone);

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
}