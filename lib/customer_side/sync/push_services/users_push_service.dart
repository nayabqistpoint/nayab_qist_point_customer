import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../hive_services/hive_box_manager.dart';
import '../core/sync_status.dart';

class UsersPushService {
  static const String collectionName = HiveBoxManager.usersBoxName;

  static Future<SyncResult> pushPending() async {
    try {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.usersBoxName);
      int count = 0;

      for (var key in box.keys) {
        final raw = box.get(key);
        if (raw is Map) {
          final data = Map<String, dynamic>.from(raw);
          // 🎯 شرط درست کر دی گئی:
          if (data['isSynced'] != true) {
            final docId = key.toString();
            final payload = Map<String, dynamic>.from(data);
            payload['isSynced'] = true;

            await FirebaseFirestore.instance
                .collection(collectionName)
                .doc(docId)
                .set(payload, SetOptions(merge: true));

            data['isSynced'] = true;
            await box.put(key, data);
            count++;
          }
        }
      }
      return SyncResult.success(count);
    } catch (e) {
      debugPrint('❌ UsersPushService Error: $e');
      return SyncResult.failure(e.toString());
    }
  }
}