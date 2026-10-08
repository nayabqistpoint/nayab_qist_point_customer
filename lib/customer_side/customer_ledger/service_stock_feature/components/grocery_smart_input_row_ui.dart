import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/service_stock_controller.dart';

class GrocerySmartInputRowUi extends StatelessWidget {
  final ServiceStockController controller;
  const GrocerySmartInputRowUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final gService = controller.groceryService;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 1. چیز کا نام (42px)
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('چیز کا نام', style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              SizedBox(
                height: 42,
                child: Autocomplete<String>(
                  optionsBuilder: (textVal) {
                    return gService.priceHistoryService.searchItems(textVal.text);
                  },
                  onSelected: (selection) => controller.selectAutocompleteItem(selection),
                  fieldViewBuilder: (ctx, textCtrl, focusNode, _) {
                    textCtrl.addListener(() {
                      gService.itemNameCtrl.text = textCtrl.text;
                    });
                    return TextFormField(
                      controller: textCtrl,
                      focusNode: focusNode,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'چیز لکھیں...',
                        hintStyle: const TextStyle(fontSize: 11),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),

        // 2. تعداد (کیپسول اسٹیپر)
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('تعداد', style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(
                height: 42,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
                  borderRadius: BorderRadius.circular(9),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onLongPressStart: (_) => controller.startFastStepper(onTick: controller.decrementQty),
                      onLongPressEnd: (_) => controller.stopFastStepper(),
                      onTap: controller.decrementQty,
                      child: Container(
                        width: 28,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                        ),
                        child: const Icon(Icons.remove, size: 16, color: Color(0xFF334155)),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '${gService.currentQty}',
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onLongPressStart: (_) => controller.startFastStepper(onTick: controller.incrementQty),
                      onLongPressEnd: (_) => controller.stopFastStepper(),
                      onTap: controller.incrementQty,
                      child: Container(
                        width: 28,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                        ),
                        child: const Icon(Icons.add, size: 16, color: Color(0xFF0D9488)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),

        // 3. ریٹ (1 روپے والا اسٹیپر)
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ریٹ (روپے)', style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(
                height: 42,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
                  borderRadius: BorderRadius.circular(9),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onLongPressStart: (_) => controller.startFastStepper(onTick: controller.decrementPrice),
                      onLongPressEnd: (_) => controller.stopFastStepper(),
                      onTap: controller.decrementPrice,
                      child: Container(
                        width: 28,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                        ),
                        child: const Icon(Icons.remove, size: 16, color: Color(0xFFDC2626)),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: gService.itemPriceCtrl,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        onChanged: controller.setManualPrice,
                      ),
                    ),
                    GestureDetector(
                      onLongPressStart: (_) => controller.startFastStepper(onTick: controller.incrementPrice),
                      onLongPressEnd: (_) => controller.stopFastStepper(),
                      onTap: controller.incrementPrice,
                      child: Container(
                        width: 28,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFCCFBF1),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                        ),
                        child: const Icon(Icons.add, size: 16, color: Color(0xFF0D9488)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),

        // 4. شامل کریں بٹن
        InkWell(
          onTap: controller.addGroceryItem,
          borderRadius: BorderRadius.circular(9),
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D9488),
              borderRadius: BorderRadius.circular(9),
              boxShadow: [
                BoxShadow(color: const Color(0xFF0D9488).withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.add, color: Colors.white, size: 16),
                SizedBox(width: 2),
                Text('شامل', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11.5)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}