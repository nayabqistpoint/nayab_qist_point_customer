import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_subview/services/payload_builders/installment_order_update_builder.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_subview/services/payload_builders/installment_transaction_history_builder.dart';

class InstallmentPayloadService {
  static Map<String, dynamic> buildAllocationPayloadBundle({
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
  }) {
    final int effectiveCreditPool = totalPaidAmount + discountAmount;
    final String orderDocId = (rawOrder['docId'] ?? rawOrder['orderId'] ?? orderKey).toString();
    final String itemName = (rawOrder['itemName'] ?? 'موبائل فون').toString();
    final String planTitle = (rawOrder['plan'] ?? 'اقساط پلان').toString();

    // 1. آرڈر کا واٹرفال اپ ڈیٹ پے لوڈ
    final orderResult = InstallmentOrderUpdateBuilder.buildUpdatedOrder(
      rawOrder: rawOrder,
      totalCollectedAmount: effectiveCreditPool,
    );

    final Map<String, dynamic> updatedOrderPayload = orderResult['orderPayload'] as Map<String, dynamic>;
    final List<String> allocationLogs = List<String>.from(orderResult['allocationLogs'] as List);

    // 2. ٹرانزیکشن ہسٹری لیجر لاگ کا پے لوڈ
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

    return {
      'orderKey': orderKey,
      'itemName': itemName,
      'updatedOrderPayload': updatedOrderPayload,
      'txnRecord': txnRecord,
      'allocationLogs': allocationLogs,
      'unallocatedSurplus': orderResult['unallocatedSurplus'] ?? 0,
    };
  }
}