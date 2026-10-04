import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_section/service_stock_controller.dart';
import 'package:nayab_qist_point_customer/customer_side/payload_services/service_stock_builders/stock_box_payload_builder.dart';
import 'package:nayab_qist_point_customer/customer_side/payload_services/service_stock_builders/grocery_transaction_builder.dart';
import 'package:nayab_qist_point_customer/customer_side/payload_services/service_stock_builders/household_grocery_expense_builder.dart';
import 'package:nayab_qist_point_customer/customer_side/payload_services/service_stock_builders/installment_credit_builder.dart';
import 'package:nayab_qist_point_customer/customer_side/sync/master_sync_hub.dart';

class ServiceStockPayloadService {
  static Future<bool> executeSubmission(ServiceStockController controller) async {
    try {
      final activePhone = controller.customerPhone.trim();
      if (activePhone.isEmpty) return false;

      // یوزرز باکس سے کسٹمر کا نام
      final usersBox = await HiveBoxManager.openSafeBox(HiveBoxManager.usersBoxName);
      final userDoc = usersBox.get(activePhone);
      final customerName = (userDoc != null ? userDoc['name'] ?? userDoc['fullName'] : 'عام کسٹمر').toString();

      final note = controller.noteCtrl.text.trim();

      // 🎯 موڈ 1: موبائل سپلائر موڈ
      if (controller.isMobileSupplierMode) {
        final stockBox = await HiveBoxManager.openSafeBox(HiveBoxManager.stockBoxName);
        for (final item in controller.mobileService.supplierStockList) {
          final doc = StockBoxPayloadBuilder.buildStockDocument(
            rawItem: item,
            activePhone: activePhone,
            supplierName: customerName,
            note: note,
          );
          // اسٹیٹس بالکل صاف
          doc['status'] = controller.mobileIntent == 1 ? 'available_on_order' : 'available';
          doc['isSynced'] = false;
          await stockBox.put(doc['itemId'], doc);
        }

        MasterSyncHub.pushAllPendingRecords().catchError((_) {});
        return true;
      } 
      // 🎯 موڈ 2: راشن بل موڈ
      else {
        final billAmount = controller.groceryTotal;
        final itemsList = List<Map<String, dynamic>>.from(controller.groceryService.groceryList);
        final txId = 'TX-GRC-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}-${100 + Random().nextInt(900)}';

        String targetTitle = 'نقد / دستی پیشگی کھاتہ';

        // 1. اگر فعال قسط چنی گئی ہے تو صرف متعلقہ آرڈر کے orderKey پر اپڈیٹ ہوگا
        if (controller.accountType == 0) {
          final product = controller.selectedProduct;
          if (product != null && product['orderKey'] != null && product['rawOrder'] != null) {
            targetTitle = 'قسط: ${product['name']}';
            final dynamic orderKey = product['orderKey'];

            // شیڈول میں کٹوتی تیار کرنا
            final updatedOrder = InstallmentCreditBuilder.buildInstallmentAdjustment(
              rawOrder: product['rawOrder'],
              billAmount: billAmount,
              note: note,
            );

            // 🎯 براہِ راست اسی آرڈر کی پر اوور رائٹ/اپڈیٹ (کوئی نیا فون نہیں بنے گا)
            final installmentsBox = await HiveBoxManager.openSafeBox(HiveBoxManager.installmentsBoxName);
            await installmentsBox.put(orderKey, updatedOrder);
          }
        }

        // 2. ٹرانزیکشن باکس میں صرف ایک ہی انٹری بنے گی
        final transactionDoc = GroceryTransactionBuilder.buildTransactionRecord(
          txId: txId,
          customerPhone: activePhone,
          customerName: customerName,
          totalAmount: billAmount,
          items: itemsList,
          targetAccountTitle: targetTitle,
          note: note,
        );
        final txBox = await HiveBoxManager.openSafeBox(HiveBoxManager.transactionBoxName);
        await txBox.put(txId, transactionDoc);

        // 3. ایپ کنفگ میں صرف خسارے کا کاؤنٹر پلس کرنا
        final appConfigBox = await HiveBoxManager.openSafeBox(HiveBoxManager.appConfigBoxName);
        final rawDiscounts = appConfigBox.get('discounts_config');
        final existingDiscounts = rawDiscounts is Map ? Map<String, dynamic>.from(rawDiscounts) : null;

        final updatedDiscounts = HouseholdGroceryExpenseBuilder.buildDiscountsLossAccumulator(
          existingConfig: existingDiscounts,
          billAmount: billAmount,
        );
        await appConfigBox.put('discounts_config', updatedDiscounts);

        // 🎯 سنک ٹرگر کرنا
        MasterSyncHub.pushAllPendingRecords().catchError((_) {});
        return true;
      }
    } catch (e) {
      debugPrint('ServiceStockPayloadService Error: $e');
      return false;
    }
  }
}