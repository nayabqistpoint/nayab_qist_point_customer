import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/service_stock_controller.dart';

class SupplierStockListUi extends StatelessWidget {
  final ServiceStockController controller;
  const SupplierStockListUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final list = controller.mobileService.supplierStockList;
    if (list.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 10),
        ...list.asMap().entries.map((entry) {
          final m = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.phone_android, color: Color(0xFF0D9488), size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('${m['itemName']} (${m['ramRom']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCCFBF1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              m['status'] == 'available_on_order' ? 'طلب پر دستیاب' : 'دکان اسٹاک',
                              style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'کوڈ: ${m['itemId']} | حالت: ${m['conditionRating']} | وارنٹی: ${m['warranty']} | لاگت: Rs. ${controller.formatAmount(m['purchasePrice'])} | سیل ریٹ: Rs. ${controller.formatAmount(m['salePrice'])}',
                        style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                  onPressed: () => controller.removeSupplierMobile(entry.key),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}