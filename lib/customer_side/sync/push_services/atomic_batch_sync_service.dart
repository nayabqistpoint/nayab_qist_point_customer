import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../hive_services/hive_box_manager.dart';
import '../core/sync_status.dart';
import '../core/connectivity_service.dart';

/// بیچ میں بھیجے جانے والے ہر انفرادی ریکارڈ کا ماڈل
class BatchOperationItem {
  final String firestoreCollection; // فائر اسٹور کا کلیکشن (مثلاً: transactions, installments)
  final String hiveBoxName;          // لوکل ہائیو باکس کا نام
  final String docId;                // ریکارڈ کی منفرد کی / آئی ڈی
  final Map<String, dynamic> data;   // اصل پے لوڈ

  const BatchOperationItem({
    required this.firestoreCollection,
    required this.hiveBoxName,
    required this.docId,
    required this.data,
  });
}

class AtomicBatchSyncService {
  /// کسی بھی پیج سے کتنے بھی باکسز کا ڈیٹا ایک ہی ہٹ میں لوکل اور کلاؤڈ پر لکھنا
  static Future<SyncResult> executeBatch(List<BatchOperationItem> operations) async {
    if (operations.isEmpty) {
      return SyncResult.failure('بیچ کے لیے کوئی آپریشن فراہم نہیں کیا گیا');
    }

    try {
      // 🎯 مرحلہ نمبر ۱: پہلے لوکل ڈسک (Hive) میں فوراً آف لائن محفوظ کریں (isSynced: false کے ساتھ)
      for (final op in operations) {
        final box = await HiveBoxManager.openSafeBox(op.hiveBoxName);
        final localRecord = Map<String, dynamic>.from(op.data);
        localRecord['isSynced'] = false;
        await box.put(op.docId, localRecord);
      }
      debugPrint('💾 لوکل ہائیو میں تمام ${operations.length} ریکارڈز (isSynced: false) محفوظ ہو گئے۔');

      // 🎯 مرحلہ نمبر ۲: انٹرنیٹ کنکشن چیک کریں
      final hasNet = await ConnectivityService.hasInternetConnection();
      if (!hasNet) {
        debugPrint('🌐 انٹرنیٹ دستیاب نہیں: ڈیٹا آف لائن ہائیو میں محفوظ ہو چکا ہے، بعد میں خودکار سنک ہوگا۔');
        return SyncResult.success(operations.length);
      }

      // 🎯 مرحلہ نمبر ۳: فائر اسٹور پر اٹامک رائٹ بیچ (All or Nothing)
      final firestore = FirebaseFirestore.instance;
      final WriteBatch batch = firestore.batch();

      for (final op in operations) {
        final docRef = firestore.collection(op.firestoreCollection).doc(op.docId);
        final cloudData = Map<String, dynamic>.from(op.data);
        cloudData['isSynced'] = true; // کلاؤڈ پر ہمیشہ سنک ٹرو جائے گا
        batch.set(docRef, cloudData, SetOptions(merge: true));
      }

      // سرور پر حتمی کمٹ
      await batch.commit();
      debugPrint('☁ فائر اسٹور پر تمام ${operations.length} ڈاکومنٹس ایک ساتھ کمٹ ہو گئے۔');

      // 🎯 مرحلہ نمبر ۴: سرور پر کامیابی کے بعد لوکل ہائیو میں بھی isSynced = true کر دیں
      for (final op in operations) {
        final box = await HiveBoxManager.openSafeBox(op.hiveBoxName);
        final syncedRecord = Map<String, dynamic>.from(op.data);
        syncedRecord['isSynced'] = true;
        await box.put(op.docId, syncedRecord);
      }

      return SyncResult.success(operations.length);
    } catch (e) {
      debugPrint('❌ اٹامک رائٹ بیچ فیل ہو گیا: $e');
      // فائر اسٹور پر کچھ نہیں گیا، ہائیو میں پہلے ہی 'isSynced: false' موجود ہے
      return SyncResult.failure(e.toString());
    }
  }
}