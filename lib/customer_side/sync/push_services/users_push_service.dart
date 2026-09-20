import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../hive_services/hive_box_manager.dart';
import '../core/sync_status.dart';

class UsersPushService {
  static const String collectionName = HiveBoxManager.usersBoxName;

  static Future<SyncResult> pushPending() async {
    try {
      final settingsBox = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
      final activePhone = settingsBox.get('activePhone', defaultValue: '') as String;

      if (activePhone.isEmpty) {
        return SyncResult.success(0);
      }

      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.usersBoxName);
      final raw = box.get(activePhone);

      // صرف فعال لاگ ان شدہ یوزر کا ڈیٹا پش کرنا
      if (raw is Map) {
        final data = Map<String, dynamic>.from(raw);
        if (data['isSynced'] != true) {
          final payload = Map<String, dynamic>.from(data);
          payload['isSynced'] = true;

          // 🎯 Doc ID لازمی موبائل نمبر ہی رہے گی
          await FirebaseFirestore.instance
              .collection(collectionName)
              .doc(activePhone)
              .set(payload, SetOptions(merge: true));

          data['isSynced'] = true;
          await box.put(activePhone, data);
          return SyncResult.success(1);
        }
      }

      return SyncResult.success(0);
    } catch (e) {
      debugPrint('❌ UsersPushService Error: $e');
      return SyncResult.failure(e.toString());
    }
  }
}