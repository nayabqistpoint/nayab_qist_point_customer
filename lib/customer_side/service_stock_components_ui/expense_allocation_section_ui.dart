import 'package:flutter/material.dart';
import '../service_stock_controller.dart';

class ExpenseAllocationSectionUi extends StatelessWidget {
  final ServiceStockController controller;

  const ExpenseAllocationSectionUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isReconciled = controller.isExpenseReconciled;
    final int diff = controller.expenseDifference;

    return Container(
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
              const Expanded(
                child: Text(
                  'ایکسپنس کیٹیگری کا انتخاب کریں:',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton.icon(
                onPressed: () => controller.addExpenseAllocation(),
                icon: const Icon(Icons.add_circle_outline, size: 15, color: Color(0xFF0D9488)),
                label: const Text(
                  'مزید خرچہ کے ذرائع',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...controller.expenseAllocations.asMap().entries.map((entry) {
            int eIdx = entry.key;
            var alloc = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: alloc['category'],
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                          items: controller.configExpenseCategories
                              .map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis)))
                              .toList(),
                          onChanged: (v) => controller.updateExpenseCategory(eIdx, v!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      key: ValueKey('expense_amount_$eIdx'),
                      initialValue: alloc['amount'].toString(),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                      onChanged: (val) => controller.updateExpenseAmount(eIdx, val),
                      decoration: InputDecoration(
                        prefixText: 'Rs. ',
                        prefixStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                      ),
                    ),
                  ),
                  if (controller.expenseAllocations.length > 1)
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 18, color: Color(0xFFDC2626)),
                      onPressed: () => controller.removeExpenseAllocation(eIdx),
                    ),
                ],
              ),
            );
          }),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isReconciled ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isReconciled ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isReconciled
                        ? '✔ خرچہ کیٹیگریز بل سے میچ ہیں'
                        : '✖ فرق: Rs. ${controller.formatAmount(diff.abs())} (${diff < 0 ? "رقم کم ہے" : "رقم زائد ہے"})',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: isReconciled ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'خرچہ: Rs. ${controller.formatAmount(controller.expenseSum)} / بل: Rs. ${controller.formatAmount(controller.totalBill)}',
                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}