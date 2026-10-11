import 'payload_builders/grocery_transaction_box_builder.dart';
import 'payload_builders/grocery_customer_box_builder.dart';

class GroceryEntryPayloadService {
  /// صرف پے لوڈ میپ تیار کر کے واپس کرتا ہے (اس میں ہائیو کا کوئی تعلق نہیں)
  static Map<String, dynamic> buildPayloads({
    required String customerPhone,
    required int grandTotal,
    required List<Map<String, dynamic>> items,
    required bool hasPhoto,
    required bool hasAudio,
    required int currentCashLoanBalance,
    required int currentInstallmentDue,
  }) {
    final txData = GroceryTransactionBoxBuilder.build(
      customerPhone: customerPhone,
      grandTotal: grandTotal,
      items: items,
      hasPhoto: hasPhoto,
      hasAudio: hasAudio,
    );

    final custUpdate = GroceryCustomerBoxBuilder.build(
      currentCashLoanBalance: currentCashLoanBalance,
      currentInstallmentDue: currentInstallmentDue,
      grandTotal: grandTotal,
    );

    return {
      'txData': txData,
      'custUpdate': custUpdate,
    };
  }
}