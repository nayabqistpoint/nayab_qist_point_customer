import 'package:flutter/foundation.dart';
import '../hive_services/hive_box_manager.dart';
import '../inspector/inspector_store.dart';
import '../sync/master_sync_hub.dart';
import 'cash_loan_payload_builders/cash_loan_transaction_builder.dart';

class CashLoanRepaymentService {
  static Future<bool> processRepayment({
    required String customerPhone,
    required int paidAmount,
    required int discountAmount,
    required List<Map<String, dynamic>> splits,
    required String note,
    String receiptImagePath = '',
    String voiceNotePath = '',
  }) async {
    try {
      final txnRecord = CashLoanTransactionBuilder.buildTransactionRecord(
        customerPhone: customerPhone,
        paidAmount: paidAmount,
        discountAmount: discountAmount,
        splits: splits,
        note: note,
        receiptImagePath: receiptImagePath,
        voiceNotePath: voiceNotePath,
      );

      final transactionBox = await HiveBoxManager.openSafeBox(HiveBoxManager.transactionBoxName);
      await transactionBox.put(txnRecord['txId'], txnRecord);

      InspectorStore.instance.logPayload(
        title: 'نقد قرض واپسی محفوظ (${txnRecord['txId']})',
        direction: PayloadDirection.localHiveWrite,
        data: txnRecord,
      );

      MasterSyncHub.pushAllPendingRecords().catchError((e) {
        debugPrint('Sync Background trigger notice (Cash Loan): $e');
      });

      return true;
    } catch (e) {
      debugPrint('❌ CashLoanRepaymentService Error: $e');
      return false;
    }
  }
}