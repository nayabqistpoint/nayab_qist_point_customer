import '../hive_services/hive_box_manager.dart';
import 'stock_entry_payload_builders/stock_entry_stock_box_builder.dart';
import 'stock_entry_payload_builders/stock_entry_transaction_box_builder.dart';
import 'stock_entry_payload_builders/stock_entry_customer_box_builder.dart';

class StockEntryPayloadService {
  static Future<void> saveStockEntry({
    required String customerPhone,
    required String model,
    required String ramRom,
    required String color,
    required String conditionType,
    required String conditionRating,
    required String imeiNo,
    required String warranty,
    required int purchasePrice,
    required double salePrice,
    required bool isPromotionalOnOrder,
    required List<String> images,
  }) async {
    final stockBoxPayload = StockEntryStockBoxBuilder.build(
      model: model,
      ramRom: ramRom,
      color: color,
      conditionType: conditionType,
      conditionRating: conditionRating,
      imeiNo: imeiNo,
      warranty: warranty,
      purchasePrice: purchasePrice,
      salePrice: salePrice,
      isPromotionalOnOrder: isPromotionalOnOrder,
      images: images,
      customerPhone: customerPhone,
    );

    final txData = StockEntryTransactionBoxBuilder.build(
      customerPhone: customerPhone,
      model: model,
      ramRom: ramRom,
      conditionRating: conditionRating,
      warranty: warranty,
      purchasePrice: purchasePrice,
      isPromotionalOnOrder: isPromotionalOnOrder,
      images: images,
    );

    final stockBox = await HiveBoxManager.openSafeBox(HiveBoxManager.stockBoxName);
    await stockBox.put(stockBoxPayload['itemId'], stockBoxPayload);

    final txBox = await HiveBoxManager.openSafeBox(HiveBoxManager.transactionBoxName);
    await txBox.put(txData['txId'], txData);

    if (!isPromotionalOnOrder) {
      final customerBox = await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);
      final customerData = customerBox.get(customerPhone);
      if (customerData is Map) {
        final int currentCashBal = (customerData['cashLoanBalance'] as num?)?.toInt() ?? 0;
        final int currentInstDue = (customerData['installmentDueBalance'] as num?)?.toInt() ?? 0;

        final custUpdate = StockEntryCustomerBoxBuilder.build(
          currentCashLoanBalance: currentCashBal,
          currentInstallmentDue: currentInstDue,
          purchasePrice: purchasePrice,
          isPromotionalOnOrder: false,
        );
        await customerBox.put(customerPhone, {
          ...Map<String, dynamic>.from(customerData),
          ...custUpdate,
        });
      }
    }
  }
}