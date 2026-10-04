// lib/customer_side/payload_services/installment_allocation_service.dart

import 'package:flutter/foundation.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'package:nayab_qist_point_customer/customer_side/inspector/inspector_store.dart';
import 'package:nayab_qist_point_customer/customer_side/sync/master_sync_hub.dart';
import 'package:nayab_qist_point_customer/customer_side/payload_services/installment_payload_builders/installment_order_update_builder.dart';
import 'package:nayab_qist_point_customer/customer_side/payload_services/installment_payload_builders/installment_transaction_history_builder.dart';

class InstallmentAllocationService {
  /// مکمل ادائیگی کا پروسیس: قسطوں میں واٹر فال کٹوتی + سنگل ٹرانزیکشن رسید کی انٹری
  static Future<bool> processPaymentAllocation({
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
      // 1. کل کریڈٹ پول (نقد ادا شدہ + ڈسکاؤنٹ کی چھوٹ)
      final int effectiveCreditPool = totalPaidAmount + discountAmount;
      final String orderDocId = (rawOrder['docId'] ?? rawOrder['orderId'] ?? orderKey).toString();
      final String itemName = (rawOrder['itemName'] ?? 'موبائل فون').toString();
      final String planTitle = (rawOrder['plan'] ?? 'اقساط پلان').toString();

      // 2. بلڈر کے ذریعے واٹر فال شیڈول تیار کریں
      final orderResult = InstallmentOrderUpdateBuilder.buildUpdatedOrder(
        rawOrder: rawOrder,
        totalCollectedAmount: effectiveCreditPool,
      );

      final Map<String, dynamic> updatedOrderPayload = orderResult['orderPayload'] as Map<String, dynamic>;
      final List<String> allocationLogs = List<String>.from(orderResult['allocationLogs'] as List);

      // 3. ٹرانزیکشن باکس کے لیے سنگل رسید کا ریکارڈ بنائیں
      final txnRecord = InstallmentTransactionHistoryBuilder.buildTransactionRecord(
        customerPhone: customerPhone,
        orderDocId: orderDocId,
        itemName: itemName,
        planTitle: planTitle,
        collectedTotal: totalPaidAmount,
        discountAmount: discountAmount,
        extraAmount: extraAmount,
        splits: splits,
        allocationSummary: allocationLogs,
        note: note,
        receiptImagePath: receiptImagePath,
        voiceNotePath: voiceNotePath,
      );

      // 4. ہائیو باکسز میں اٹامک طریقے سے محفوظ کریں
      final installmentsBox = await HiveBoxManager.openSafeBox(HiveBoxManager.installmentsBoxName);
      final transactionBox = await HiveBoxManager.openSafeBox(HiveBoxManager.transactionBoxName);

      // قسطوں کا ٹیبل اوور رائٹ
      await installmentsBox.put(orderKey, updatedOrderPayload);

      // ٹرانزیکشن ہسٹری میں نیا ریکارڈ داخل
      await transactionBox.put(txnRecord['txId'], txnRecord);

      // 5. انسپکٹر اسٹور میں لاگنگ
      InspectorStore.instance.logPayload(
        title: 'اقساط واٹر فال وصولی محفوظ ($itemName)',
        direction: PayloadDirection.localHiveWrite,
        data: {
          'updatedOrder': updatedOrderPayload,
          'transactionRecord': txnRecord,
        },
      );

      // 6. کلاؤڈ سنک ہب کو نوٹیفائی کریں (آف لائن محفوظ، آن لائن ہوتے ہی پش ہوگا)
      MasterSyncHub.pushAllPendingRecords().catchError((e) {
        debugPrint('Sync Background trigger notice: $e');
      });

      return true;
    } catch (e) {
      debugPrint('❌ InstallmentAllocationService Error: $e');
      return false;
    }
  }
}