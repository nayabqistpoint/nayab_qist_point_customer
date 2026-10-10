import '../hive_services/hive_box_manager.dart';
import 'transfer_payload_builders/transfer_installments_box_builder.dart';
import 'transfer_payload_builders/transfer_transaction_box_builder.dart';

class TransferToInstallmentPayloadService {
  static Future<void> executeTransfer({
    required String customerPhone,
    required String contractDocId,
    required String productName,
    required int transferAmount,
  }) async {
    final String nowIso = DateTime.now().toIso8601String();

    // 1. installmentsBox (کسٹمر فون یا یونیک آرڈر کی تلاش اور اپ ڈیٹ)
    final instBox = await HiveBoxManager.openSafeBox(HiveBoxManager.installmentsBoxName);
    dynamic rawTargetDoc;
    dynamic targetKey;
    for (var key in instBox.keys) {
      final doc = instBox.get(key);
      if (doc is Map && doc['customerPhone'] == customerPhone && doc['docId'] == contractDocId) {
        rawTargetDoc = doc;
        targetKey = key;
        break;
      }
    }

    if (rawTargetDoc != null) {
      final updatedContract = TransferInstallmentsBoxBuilder.build(
        existingContractDoc: Map<String, dynamic>.from(rawTargetDoc),
        transferAmount: transferAmount,
      );
      await instBox.put(targetKey, updatedContract);
    }

    // 2. transactionBox (نیا یونیک ٹرانزیکشن ڈاکومنٹ)
    final txData = TransferTransactionBoxBuilder.build(
      customerPhone: customerPhone,
      productName: productName,
      transferAmount: transferAmount,
    );
    final txBox = await HiveBoxManager.openSafeBox(HiveBoxManager.transactionBoxName);
    await txBox.put(txData['txId'], txData);

    // 3. customerBox (صارف کے فون نمبر والی کی پر فنانشل فیلڈز اور سنک اسٹیٹس)
    final custBox = await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);
    final custData = custBox.get(customerPhone);
    if (custData is Map) {
      final int oldCashBal = (custData['cashLoanBalance'] as num?)?.toInt() ?? 0;
      final int oldInstBal = (custData['installmentDueBalance'] as num?)?.toInt() ?? 0;

      final int newCashBal = oldCashBal + transferAmount;
      final int newInstBal = (oldInstBal - transferAmount).clamp(0, oldInstBal);

      await custBox.put(customerPhone, {
        ...Map<String, dynamic>.from(custData),
        'customerPhone': customerPhone,
        'cashLoanBalance': newCashBal,
        'installmentDueBalance': newInstBal,
        'grandNetTotal': newCashBal + newInstBal,
        'updatedAt': nowIso,
        'lastUpdated': nowIso,
        'isSynced': false, // ☁️ سنک ٹریگر
      });
    }
  }
}