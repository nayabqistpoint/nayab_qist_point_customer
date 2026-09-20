import 'package:flutter/foundation.dart';
import 'hive_box_manager.dart';
import '../inspector/inspector_store.dart';

class UniversalPaymentHiveService {
  static Future<bool> executePaymentRecord({
    required String docId,
    required String customerPhone,
    required Map<String, dynamic> transactionPayload,
    required Map<String, dynamic> mediaPayload,
  }) async {
    try {
      // 1. ٹرانزیکشن باکس میں یونیک docId کے ساتھ محفوظ کرنا (کبھی اوور رائٹ نہیں ہوگا)
      final txnBox = await HiveBoxManager.openSafeBox(HiveBoxManager.transactionBoxName);
      await txnBox.put(docId, transactionPayload);

      // 2. میڈیا باکس میں محفوظ کرنا
      final mediaBox = await HiveBoxManager.openSafeBox(HiveBoxManager.mediaBoxName);
      await mediaBox.put(docId, mediaPayload);

      // 3. شفاف انسپکٹر لاگ
      InspectorStore.instance.logPayload(
        title: 'ادائیگی محفوظ (Phone: $customerPhone | Doc: $docId)',
        direction: PayloadDirection.localHiveWrite,
        data: {
          'transactionBox': transactionPayload,
          'mediaBox': mediaPayload,
        },
      );

      return true;
    } catch (e, stack) {
      debugPrint('❌ Hive Save Error: $e');
      debugPrint(stack.toString());
      return false;
    }
  }
}