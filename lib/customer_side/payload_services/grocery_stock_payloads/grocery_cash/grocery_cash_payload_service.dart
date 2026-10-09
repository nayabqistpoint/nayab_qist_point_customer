import 'package:flutter/foundation.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/service_stock_controller.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'package:nayab_qist_point_customer/customer_side/payload_services/grocery_stock_payloads/grocery_cash/builders/transactions_box_builder.dart';

class GroceryCashPayloadService {
  static Future<bool> submitGroceryBill(ServiceStockController controller) async {
    try {
      final txPayload = TransactionsBoxBuilder.buildGroceryTransaction(
        customerPhone: controller.customerPhone,
        items: controller.groceryService.groceryList,
        totalAmount: controller.groceryTotal,
        note: controller.noteCtrl.text,
        hasPhoto: controller.hasPhoto,
        hasAudio: controller.hasAudio,
      );

      // HiveBoxManager کے محفوظ طریقہ کار سے باکس حاصل کرنا
      final box = await HiveBoxManager.openSafeBox('transactionsBox');
      await box.put(txPayload['txId'], txPayload);

      return true;
    } catch (e) {
      debugPrint('GroceryCashPayloadService Error: $e');
      return false;
    }
  }
}