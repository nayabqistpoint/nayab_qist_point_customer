import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'transfer_to_installment_payload_service.dart';

class TransferStorageHandler {
  TransferStorageHandler._();

  static ValueListenable<Box>? get customerBoxListenable {
    if (Hive.isBoxOpen(HiveBoxManager.customerBoxName)) {
      return Hive.box(HiveBoxManager.customerBoxName).listenable();
    }
    return null;
  }

  static Future<bool> executeTransfer({
    required String customerPhone,
    required String contractDocId,
    required String productName,
    required int transferAmount,
  }) async {
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
      batchPayloads[HiveBoxManager.customerBoxName] =
          TransferToInstallmentPayloadService.buildCustomerPayload(
            existingCustomerDoc: Map<String, dynamic>.from(custData),
            transferAmount: transferAmount,
          );
    }

    return await HiveBoxManager.writeBatchPayloads(
      docId: customerPhone,
      payloads: batchPayloads,
      logTitle: 'ٹرانسفر ٹو انسٹالمنٹ بیچ محفوظ ہوا',
    );
  }
}