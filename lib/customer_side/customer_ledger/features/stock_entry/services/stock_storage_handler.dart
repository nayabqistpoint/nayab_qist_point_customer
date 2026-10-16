import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'stock_entry_payload_service.dart';

class StockStorageHandler {
  static Future<bool> saveStockEntry({
    required String customerPhone,
    required String category,
    required String model,
    required String ramRom,
    required String color,
    required String conditionType,
    required String conditionRating,
    required String imeiNo,
    required String warranty,
    required String generalSpecs,
    required int purchasePrice,
    required double salePrice,
    required bool isPromotionalOnOrder,
    required List<String> images,
  }) async {
    final customerBox = await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);
    final rawCustomer = customerBox.get(customerPhone);
    final customerData = rawCustomer is Map ? Map<String, dynamic>.from(rawCustomer) : null;

    final currentCashBal = (customerData?['cashLoanBalance'] as num?)?.toInt() ?? 0;
    final currentInstDue = (customerData?['installmentDueBalance'] as num?)?.toInt() ?? 0;

    final payloads = StockEntryPayloadService.buildPayloads(
      customerPhone: customerPhone,
      category: category,
      model: model,
      ramRom: ramRom,
      color: color,
      conditionType: conditionType,
      conditionRating: conditionRating,
      imeiNo: imeiNo,
      warranty: warranty,
      generalSpecs: generalSpecs,
      purchasePrice: purchasePrice,
      salePrice: salePrice,
      isPromotionalOnOrder: isPromotionalOnOrder,
      images: images,
      currentCashBal: currentCashBal,
      currentInstDue: currentInstDue,
    );

    final Map<String, Map<String, dynamic>> batchPayloads = {
      HiveBoxManager.stockBoxName: payloads['stockPayload']!,
      HiveBoxManager.transactionBoxName: payloads['txPayload']!,
    };

    if (payloads['custUpdate'] != null && customerData != null) {
      batchPayloads[HiveBoxManager.customerBoxName] = {
        ...customerData,
        ...payloads['custUpdate']!,
      };
    }

    return await HiveBoxManager.writeBatchPayloads(
      docId: customerPhone,
      payloads: batchPayloads,
      logTitle: 'اسٹاک انٹری بیچ محفوظ ہوئی',
    );
  }
}