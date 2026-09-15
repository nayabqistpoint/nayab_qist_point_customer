import 'package:flutter/material.dart';
import '../service_stock_controller.dart';

class GroceryEntrySectionUi extends StatelessWidget {
  final ServiceStockController controller;

  const GroceryEntrySectionUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'راشن / گروسری کی اشیاء:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            Text(
              'کل بل: Rs. ${controller.formatAmount(controller.totalBill)}',
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Color(0xFF0D9488)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...controller.groceryList.asMap().entries.map((e) {
          int idx = e.key;
          var item = e.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${idx + 1}. ${item['name']}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                ),
                Row(
                  children: [
                    Text(
                      'Rs. ${controller.formatAmount(item['amount'])}',
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    if (controller.groceryList.length > 1)
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: Color(0xFFDC2626)),
                        onPressed: () => controller.removeGroceryItem(idx),
                      ),
                  ],
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 44,
                child: TextFormField(
                  controller: controller.itemNameCtrl,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: 'چیز کا نام (دال، گھی)',
                    hintStyle: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 44,
                child: TextFormField(
                  controller: controller.itemAmountCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                  decoration: InputDecoration(
                    hintText: 'قیمت',
                    hintStyle: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                    prefixText: 'Rs. ',
                    prefixStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: () => controller.addGroceryItem(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('شامل کریں', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}