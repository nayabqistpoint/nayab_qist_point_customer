import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'package:nayab_qist_point_customer/customer_side/sync/core/sync_status.dart';

class StockPushService {
  static const String collectionName = HiveBoxManager.stockBoxName;

  static Future<SyncResult> pushPending() async {
    try {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.stockBoxName);
      int count = 0;

      for (var key in box.keys) {
        final raw = box.get(key);
        if (raw is Map) {
          final data = Map<String, dynamic>.from(raw);

          // 🌟 جو اسٹاک فائر اسٹور پر سنک نہیں ہوا (isSynced != true) اسے پش کرنا
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
            debugPrint('🚀 [stockBox] کامیابی سے فائر اسٹور پر سنک ہو گیا: $docId');
          }
        }
      }
      return SyncResult.success(count);
    } catch (e) {
      debugPrint('❌ StockPushService Error: $e');
      return SyncResult.failure(e.toString());
    }
  }
}