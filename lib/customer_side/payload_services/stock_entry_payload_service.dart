import '../hive_services/hive_box_manager.dart';
import '../sync/master_sync_hub.dart';
import 'stock_entry_payload_builders/stock_entry_stock_box_builder.dart';
import 'stock_entry_payload_builders/stock_entry_transaction_box_builder.dart';
import 'stock_entry_payload_builders/stock_entry_customer_box_builder.dart';

class StockEntryPayloadService {
  static Future<void> saveStockEntry({
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
    // ۱. stockBox پے لوڈ کی تیاری
    final stockBoxPayload = StockEntryStockBoxBuilder.build(
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
      customerPhone: customerPhone,
    );

    // ۲. transactionBox پے لوڈ کی تیاری
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

    // ۳. اسٹاک باکس میں محفوظ کرنا
    final stockBox = await HiveBoxManager.openSafeBox(HiveBoxManager.stockBoxName);
    await stockBox.put(stockBoxPayload['itemId'], stockBoxPayload);

    // ۴. ٹرانزیکشن باکس میں محفوظ کرنا
    final txBox = await HiveBoxManager.openSafeBox(HiveBoxManager.transactionBoxName);
    await txBox.put(txData['txId'], txData);

    // ۵. کسٹمر کھاتے پر نقد کٹوتی (اگر پروموشنل نہ ہو)
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

    // ۶. فائر اسٹور پر پش ٹریگر
    MasterSyncHub.pushAllPendingRecords().catchError((_) {});
  }
}