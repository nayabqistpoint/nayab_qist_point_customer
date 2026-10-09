import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/service_stock_controller.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/components/service_stock_app_bar_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/components/stock_nature_toggle_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/components/grocery_items_list_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/components/grocery_smart_input_row_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/components/mobile_intent_banner_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/components/supplier_mobile_form_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/components/supplier_stock_list_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/components/note_media_bar_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/components/service_stock_submit_button_ui.dart';

class ServiceStockEntryPage extends StatefulWidget {
  final String customerPhone;

  const ServiceStockEntryPage({
    super.key,
    this.customerPhone = '',
  });

  @override
  State<ServiceStockEntryPage> createState() => _ServiceStockEntryPageState();
}

class _ServiceStockEntryPageState extends State<ServiceStockEntryPage> {
  late ServiceStockController controller;

  @override
  void initState() {
    super.initState();
    controller = ServiceStockController(customerPhone: widget.customerPhone);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: const ServiceStockAppBarUi(),
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StockNatureToggleUi(controller: controller),
                  const SizedBox(height: 14),
                  if (controller.mainMode == 0) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('راشن اشیاء کا بل (نقد کھاتہ):', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              Text(
                                'کل بل: Rs. ${controller.formatAmount(controller.groceryTotal)}',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0D9488)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          GroceryItemsListUi(controller: controller),
                          const SizedBox(height: 12),
                          GrocerySmartInputRowUi(controller: controller),
                        ],
                      ),
                    ),
                  ] else ...[
                    MobileIntentBannerUi(controller: controller),
                    const SizedBox(height: 12),
                    SupplierMobileFormUi(controller: controller),
                    SupplierStockListUi(controller: controller),
                  ],
                  const SizedBox(height: 16),
                  NoteMediaBarUi(controller: controller),
                  const SizedBox(height: 20),
                  ServiceStockSubmitButtonUi(controller: controller),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}