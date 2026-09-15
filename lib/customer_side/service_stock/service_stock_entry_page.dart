import 'package:flutter/material.dart';
import 'service_stock_controller.dart';
import 'service_stock_components_ui/service_stock_app_bar_ui.dart';
import 'service_stock_components_ui/stock_nature_toggle_ui.dart';
import 'service_stock_components_ui/target_account_selector_ui.dart';
import 'service_stock_components_ui/grocery_entry_section_ui.dart';
import 'service_stock_components_ui/expense_allocation_section_ui.dart';
import 'service_stock_components_ui/mobile_stock_section_ui.dart';
import 'service_stock_components_ui/note_media_bar_ui.dart';
import 'service_stock_components_ui/service_stock_submit_button_ui.dart';

class ServiceStockEntryPage extends StatefulWidget {
  final List<String> targetAccounts;

  const ServiceStockEntryPage({super.key, required this.targetAccounts});

  @override
  State<ServiceStockEntryPage> createState() => _ServiceStockEntryPageState();
}

class _ServiceStockEntryPageState extends State<ServiceStockEntryPage> {
  ServiceStockController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = ServiceStockController(targetAccounts: widget.targetAccounts);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller ??= ServiceStockController(targetAccounts: widget.targetAccounts);
    final controller = _controller!;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: const ServiceStockAppBarUi(),
            body: SingleChildScrollView(
              // 👈 یہ پراپرٹی پیج کو ہمیشہ اور ہر حال میں اسکرولیبل رکھتی ہے
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StockNatureToggleUi(controller: controller),
                  const SizedBox(height: 14),
                  TargetAccountSelectorUi(controller: controller),
                  const SizedBox(height: 16),
                  if (!controller.isStockBarter) ...[
                    GroceryEntrySectionUi(controller: controller),
                    const SizedBox(height: 16),
                    ExpenseAllocationSectionUi(controller: controller),
                  ] else ...[
                    MobileStockSectionUi(controller: controller),
                  ],
                  const SizedBox(height: 16),
                  NoteMediaBarUi(controller: controller),
                  const SizedBox(height: 24),
                  ServiceStockSubmitButtonUi(controller: controller),

                  // 👈 اضافی اسپیس تاکہ پورا پیج اور آخری بٹن انگوٹھے سے اوپر تک کھینچا جا سکے
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}