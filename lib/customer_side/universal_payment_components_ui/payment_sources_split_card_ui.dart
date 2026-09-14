import 'package:flutter/material.dart';
import '../universal_payment_controller.dart';

class PaymentSourcesSplitCardUi extends StatelessWidget {
  final UniversalPaymentController controller;
  final VoidCallback onStateChange;

  const PaymentSourcesSplitCardUi({
    super.key,
    required this.controller,
    required this.onStateChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'بینک و کیش سورسز (اسپلٹ ادائیگی):',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                controller.addSplitEntry();
                onStateChange();
              },
              icon: const Icon(Icons.add_circle_outline_rounded, size: 16, color: Color(0xFF0D9488)),
              label: const Text('دوسرا سورس جوڑیں', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0D9488))),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...controller.splitEntries.asMap().entries.map((entry) {
          int idx = entry.key;
          Map<String, dynamic> item = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCBD5E1)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: item['source'],
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        items: controller.configPaymentSources.map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (v) {
                          controller.updateSplitEntry(idx, v ?? controller.configPaymentSources.first, item['amount'] ?? 0);
                          onStateChange();
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: item['amount'].toString(),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                    onChanged: (v) {
                      controller.updateSplitEntry(idx, item['source'], int.tryParse(v) ?? 0);
                      onStateChange();
                    },
                    decoration: InputDecoration(
                      prefixText: 'Rs. ',
                      prefixStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                  ),
                ),
                if (controller.splitEntries.length > 1)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20, color: Color(0xFFDC2626)),
                    onPressed: () {
                      controller.removeSplitEntry(idx);
                      onStateChange();
                    },
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
}