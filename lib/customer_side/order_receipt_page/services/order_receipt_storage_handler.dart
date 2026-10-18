import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'package:nayab_qist_point_customer/customer_side/order_receipt_page/services/purchase_order_payload_service.dart';

class OrderReceiptStorageHandler {
  static Map<String, dynamic> buildOrderPayload({
    required String docId,
    required String customerPhone,
    required String sourceMode,
    required String itemName,
    String? imeiNo,
    required String guaranteeType,
    String? bankName,
    String? chequeNo,
    required int totalMonths,
    required int advance,
    required int monthlyAmount,
    required int totalContractAmount,
    required DateTime orderDateTime,
  }) {
    return PurchaseOrderPayloadService.buildOrderPayload(
      docId: docId,
      customerPhone: customerPhone,
      sourceMode: sourceMode,
      itemName: itemName,
      imeiNo: imeiNo,
      guaranteeType: guaranteeType,
      bankName: bankName,
      chequeNo: chequeNo,
      totalMonths: totalMonths,
      advance: advance,
      monthlyAmount: monthlyAmount,
      totalContractAmount: totalContractAmount,
      orderDateTime: orderDateTime,
    );
  }

  /// ہائیو میں اٹامک بیچ رائٹ - سنک اندر سے خود بخود ٹرگر ہو جائے گا
  static Future<bool> saveOrderRecord({
    required String tokenNo,
    required Map<String, dynamic> payload,
  }) async {
    return await HiveBoxManager.writeBatchPayloads(
      docId: tokenNo,
      payloads: {
        HiveBoxManager.installmentsBoxName: {
          tokenNo: payload,
        },
      },
      logTitle: 'نیا اقساط آرڈر بک ہوا',
    );
  }
}