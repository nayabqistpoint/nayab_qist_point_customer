import 'package:flutter/foundation.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/service_stock_controller.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'package:nayab_qist_point_customer/customer_side/payload_services/grocery_stock_payloads/supplier_stock/builders/stock_box_builder.dart';

class SupplierStockPayloadService {
  static Future<bool> submitStock(ServiceStockController controller) async {
    try {
      final stockPayloads = StockBoxBuilder.buildStockItems(
        stockList: controller.mobileService.supplierStockList,
        supplierPhone: controller.customerPhone,
      );

      // HiveBoxManager کے محفوظ میتھڈ openSafeBox کا استعمال
      final box = await HiveBoxManager.openSafeBox('stockBox');
      for (final item in stockPayloads) {
        await box.put(item['itemId'], item);
      }

      return true;
    } catch (e) {
      debugPrint('SupplierStockPayloadService Error: $e');
      return false;
    }
  }
}