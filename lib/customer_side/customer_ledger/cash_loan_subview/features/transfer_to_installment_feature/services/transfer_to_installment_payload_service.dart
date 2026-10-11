import 'payload_builders/transfer_installments_box_builder.dart';
import 'payload_builders/transfer_transaction_box_builder.dart';

class TransferToInstallmentPayloadService {
  static Map<String, dynamic> buildTransactionPayload({
    required String customerPhone,
    required String productName,
    required int transferAmount,
  }) {
    return TransferTransactionBoxBuilder.build(
      customerPhone: customerPhone,
      productName: productName,
      transferAmount: transferAmount,
    );
  }

  static Map<String, dynamic> buildContractPayload({
    required Map<String, dynamic> existingContractDoc,
    required int transferAmount,
  }) {
    return TransferInstallmentsBoxBuilder.build(
      existingContractDoc: existingContractDoc,
      transferAmount: transferAmount,
    );
  }
}