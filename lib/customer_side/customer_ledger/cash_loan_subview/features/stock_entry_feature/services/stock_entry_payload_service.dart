import 'payload_builders/stock_entry_stock_box_builder.dart';
import 'payload_builders/stock_entry_transaction_box_builder.dart';
import 'payload_builders/stock_entry_customer_box_builder.dart';

class StockEntryPayloadService {
  static Map<String, dynamic> buildPayloads({
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
    required int currentCashBal,
    required int currentInstDue,
  }) {
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

    Map<String, dynamic>? custUpdate;
    if (!isPromotionalOnOrder) {
      custUpdate = StockEntryCustomerBoxBuilder.build(
        currentCashLoanBalance: currentCashBal,
        currentInstallmentDue: currentInstDue,
        purchasePrice: purchasePrice,
        isPromotionalOnOrder: false,
      );
    }

    return {
      'stockPayload': stockBoxPayload,
      'txPayload': txData,
      'custUpdate': custUpdate,
    };
  }
}