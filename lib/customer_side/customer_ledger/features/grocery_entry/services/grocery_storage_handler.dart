import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'grocery_entry_payload_service.dart';

class GroceryStorageHandler {
  /// کسٹمر ڈیٹا پڑھتا ہے، پے لوڈ تیار کرواتا ہے اور سنگل بیچ میں محفوظ کرتا ہے
  static Future<bool> saveGrocery({
    required String customerPhone,
    required int grandTotal,
    required List<Map<String, dynamic>> items,
    required bool hasPhoto,
    required bool hasAudio,
  }) async {
    final customerBox = await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);
    final rawCustomer = customerBox.get(customerPhone);
    final customerData = rawCustomer is Map ? Map<String, dynamic>.from(rawCustomer) : null;

    final payloads = GroceryEntryPayloadService.buildPayloads(
      customerPhone: customerPhone,
      grandTotal: grandTotal,
      items: items,
      hasPhoto: hasPhoto,
      hasAudio: hasAudio,
      currentCashLoanBalance: (customerData?['cashLoanBalance'] as num?)?.toInt() ?? 0,
      currentInstallmentDue: (customerData?['installmentDueBalance'] as num?)?.toInt() ?? 0,
    );

    return await HiveBoxManager.writeBatchPayloads(
      docId: customerPhone,
      payloads: {
        HiveBoxManager.transactionBoxName: payloads['txData'],
        HiveBoxManager.customerBoxName: customerData != null
            ? {...customerData, ...payloads['custUpdate']}
            : payloads['custUpdate'],
      },
      logTitle: 'گراسری اینٹری بیچ محفوظ ہوئی',
    );
  }
}