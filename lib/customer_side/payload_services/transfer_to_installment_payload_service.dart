import '../hive_services/hive_box_manager.dart';
import 'transfer_payload_builders/transfer_installments_box_builder.dart';
import 'transfer_payload_builders/transfer_transaction_box_builder.dart';
import 'transfer_payload_builders/transfer_customer_box_builder.dart';

class TransferToInstallmentPayloadService {
  static Future<void> executeTransfer({
    required String customerPhone,
    required Map<String, dynamic> targetProduct,
    required int transferAmount,
  }) async {
    final customerBox = await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);
    final customerData = customerBox.get(customerPhone);
    final int currentBal = (customerData is Map ? customerData['cashLoanBalance'] : 0) ?? 0;

    final txData = TransferTransactionBoxBuilder.build(
      customerPhone: customerPhone,
      productName: targetProduct['name']?.toString() ?? 'موبائل فون',
      transferAmount: transferAmount,
    );

    final custUpdate = TransferCustomerBoxBuilder.build(
      currentCashLoanBalance: currentBal,
      transferAmount: transferAmount,
    );

    final instUpdate = TransferInstallmentsBoxBuilder.build(
      existingProductDoc: targetProduct,
      transferAmount: transferAmount,
    );

    // 1. Transaction Box (نیا منفرد واؤچر)
    final txBox = await HiveBoxManager.openSafeBox(HiveBoxManager.transactionBoxName);
    await txBox.put(txData['txId'], txData);

    // 2. Customer Box (نقد ادھار میں کمی)
    if (customerData is Map) {
      await customerBox.put(customerPhone, {
        ...Map<String, dynamic>.from(customerData),
        ...custUpdate,
      });
    }

    // 3. Installments Box (قسطوں کی کٹوتی اپ ڈیٹ)
    final instBox = await HiveBoxManager.openSafeBox(HiveBoxManager.installmentsBoxName);
    final instData = instBox.get(customerPhone);
    if (instData is Map) {
      await instBox.put(customerPhone, {
        ...Map<String, dynamic>.from(instData),
        ...instUpdate,
        'lastPaymentDate': DateTime.now().toIso8601String(),
      });
    }
  }
}