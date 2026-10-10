import '../hive_services/hive_box_manager.dart';
import 'grocery_payload_builders/grocery_transaction_box_builder.dart';
import 'grocery_payload_builders/grocery_customer_box_builder.dart';

class GroceryEntryPayloadService {
  static Future<void> saveGroceryEntry({
    required String customerPhone,
    required int grandTotal,
    required List<Map<String, dynamic>> items,
    required bool hasPhoto,
    required bool hasAudio,
  }) async {
    final customerBox = await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);
    final customerData = customerBox.get(customerPhone);
    final int currentBal = (customerData is Map ? customerData['cashLoanBalance'] : 0) ?? 0;

    final txData = GroceryTransactionBoxBuilder.build(
      customerPhone: customerPhone,
      grandTotal: grandTotal,
      items: items,
      hasPhoto: hasPhoto,
      hasAudio: hasAudio,
    );

    final custUpdate = GroceryCustomerBoxBuilder.build(
      currentCashLoanBalance: currentBal,
      grandTotal: grandTotal,
    );

    final txBox = await HiveBoxManager.openSafeBox(HiveBoxManager.transactionBoxName);
    await txBox.put(txData['txId'], txData);

    if (customerData is Map) {
      await customerBox.put(customerPhone, {
        ...Map<String, dynamic>.from(customerData),
        ...custUpdate,
      });
    }
  }
}