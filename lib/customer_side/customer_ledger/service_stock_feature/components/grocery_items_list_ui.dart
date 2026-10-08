import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/service_stock_controller.dart';

class GroceryItemsListUi extends StatelessWidget {
  final ServiceStockController controller;
  const GroceryItemsListUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final list = controller.groceryService.groceryList;
    return Column(
      children: list.asMap().entries.map((e) {
        final item = e.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text('${e.key + 1}. ${item['name']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 2,
                child: Text('تعداد: ${item['qty']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ),
              Text('Rs. ${controller.formatAmount(item['amount'])}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.close, size: 16, color: Colors.red),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => controller.removeGroceryItem(e.key),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}