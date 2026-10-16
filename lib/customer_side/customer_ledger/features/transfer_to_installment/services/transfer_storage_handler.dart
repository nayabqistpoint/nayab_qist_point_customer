import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'transfer_to_installment_payload_service.dart';

class TransferStorageHandler {
  static Future<bool> executeTransfer({
    required String customerPhone,
    required String contractDocId,
    required String productName,
    required int transferAmount,
  }) async {
    final String nowIso = DateTime.now().toIso8601String();

    final txPayload = TransferToInstallmentPayloadService.buildTransactionPayload(
      customerPhone: customerPhone,
      productName: productName,
      transferAmount: transferAmount,
    );

    final Map<String, Map<String, dynamic>> batchPayloads = {
      HiveBoxManager.transactionBoxName: txPayload,
    };

    final instBox = await HiveBoxManager.openSafeBox(HiveBoxManager.installmentsBoxName);
    for (var key in instBox.keys) {
      final doc = instBox.get(key);
      if (doc is Map && doc['customerPhone'] == customerPhone && doc['docId'] == contractDocId) {
        batchPayloads[HiveBoxManager.installmentsBoxName] = 
            TransferToInstallmentPayloadService.buildContractPayload(
              existingContractDoc: Map<String, dynamic>.from(doc),
              transferAmount: transferAmount,
            );
        break;
      }
    }

    final custBox = await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);
    final custData = custBox.get(customerPhone);
    if (custData is Map) {
      final int oldCashBal = (custData['cashLoanBalance'] as num?)?.toInt() ?? 0;
      final int oldInstBal = (custData['installmentDueBalance'] as num?)?.toInt() ?? 0;

      final int newCashBal = oldCashBal + transferAmount;
      final int newInstBal = (oldInstBal - transferAmount).clamp(0, oldInstBal);

      batchPayloads[HiveBoxManager.customerBoxName] = {
        ...Map<String, dynamic>.from(custData),
        'customerPhone': customerPhone,
        'cashLoanBalance': newCashBal,
        'installmentDueBalance': newInstBal,
        'grandNetTotal': newCashBal + newInstBal,
        'updatedAt': nowIso,
        'lastUpdated': nowIso,
        'isSynced': false,
      };
    }

    return await HiveBoxManager.writeBatchPayloads(
      docId: customerPhone,
      payloads: batchPayloads,
      logTitle: 'ٹرانسفر ٹو انسٹالمنٹ بیچ محفوظ ہوا',
    );
  }
}