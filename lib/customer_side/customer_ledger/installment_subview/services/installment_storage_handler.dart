import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'package:nayab_qist_point_customer/customer_side/inspector/inspector_store.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_subview/services/installment_payload_service.dart';

class InstallmentStorageHandler {
  /// ہائیو سے کسٹمر کے تمام کچے آرڈرز ریڈ کرنا
  static Future<List<Map<dynamic, dynamic>>> getCustomerRawOrders(String customerPhone) async {
    final box = await HiveBoxManager.openSafeBox(HiveBoxManager.installmentsBoxName);
    final cleanPhone = customerPhone.replaceAll(RegExp(r'\s+'), '').trim();
    final List<Map<dynamic, dynamic>> list = [];

    for (var key in box.keys) {
      final rawData = box.get(key);
      if (rawData is Map) {
        final orderPhone = (rawData['customerPhone'] ?? '')
            .toString()
            .replaceAll(RegExp(r'\s+'), '')
            .trim();
        final bool isMatch = cleanPhone.isNotEmpty &&
            (orderPhone == cleanPhone ||
                (cleanPhone.length >= 10 && orderPhone.endsWith(cleanPhone.substring(cleanPhone.length - 10))));
        if (isMatch) {
          list.add({
            'orderKey': key,
            ...Map<dynamic, dynamic>.from(rawData),
          });
        }
      }
    }
    return list;
  }

  /// ہائیو باکس کے لائیو مشاہدے کے لیے لسن ایبل
  static ValueListenable<Box>? get installmentsListenable {
    if (Hive.isBoxOpen(HiveBoxManager.installmentsBoxName)) {
      return Hive.box(HiveBoxManager.installmentsBoxName).listenable();
    }
    return null;
  }

  /// قسطوں کی تقسیم اور واٹرفال وصولی کا خالص بیچ رائٹ
  static Future<bool> executeBatchAllocation({
    required String customerPhone,
    required dynamic orderKey,
    required Map<dynamic, dynamic> rawOrder,
    required int totalPaidAmount,
    required int discountAmount,
    required int extraAmount,
    required List<Map<String, dynamic>> splits,
    required String note,
    String receiptImagePath = '',
    String voiceNotePath = '',
  }) async {
    try {
      final bundle = InstallmentPayloadService.buildAllocationPayloadBundle(
        customerPhone: customerPhone,
        orderKey: orderKey,
        rawOrder: rawOrder,
        totalPaidAmount: totalPaidAmount,
        discountAmount: discountAmount,
        extraAmount: extraAmount,
        splits: splits,
        note: note,
        receiptImagePath: receiptImagePath,
        voiceNotePath: voiceNotePath,
      );

      final Map<String, dynamic> updatedOrderPayload = bundle['updatedOrderPayload'];
      final Map<String, dynamic> txnRecord = bundle['txnRecord'];
      final String txId = txnRecord['txId'].toString();

      // سٹرکٹ ٹائپنگ: Map<String, Map<String, dynamic>>
      final Map<String, Map<String, dynamic>> batchPayload = {
        HiveBoxManager.installmentsBoxName: {
          orderKey.toString(): updatedOrderPayload,
        },
        HiveBoxManager.transactionBoxName: {
          txId: txnRecord,
        },
      };

      // ایٹامک بیچ رائٹ
      await HiveBoxManager.writeBatchPayloads(
        docId: orderKey.toString(),
        payloads: batchPayload,
      );

      InspectorStore.instance.logPayload(
        title: 'اقساط واٹر فال وصولی محفوظ (${bundle['itemName']})',
        direction: PayloadDirection.localHiveWrite,
        data: batchPayload,
      );

      return true;
    } catch (e) {
      debugPrint('❌ InstallmentStorageHandler Batch Write Error: $e');
      return false;
    }
  }
}