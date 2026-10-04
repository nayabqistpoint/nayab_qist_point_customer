import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_section/service_stock_controller.dart';

class StockNatureToggleUi extends StatelessWidget {
  final ServiceStockController controller;
  const StockNatureToggleUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isGrocery = controller.mainMode == 0;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => controller.setMainMode(0),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
                decoration: BoxDecoration(
                  color: isGrocery ? const Color(0xFF0D9488) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isGrocery
                      ? [BoxShadow(color: const Color(0xFF0D9488).withValues(alpha: 0.25), blurRadius: 4, offset: const Offset(0, 2))]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isGrocery ? Icons.check_circle_rounded : Icons.shopping_cart_rounded,
                      size: 16,
                      color: isGrocery ? Colors.white : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'کریانہ راشن بل (ایڈجسٹمنٹ)',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: isGrocery ? Colors.white : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: InkWell(
              onTap: () => controller.setMainMode(1),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
                decoration: BoxDecoration(
                  color: !isGrocery ? const Color(0xFF0D9488) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: !isGrocery
                      ? [BoxShadow(color: const Color(0xFF0D9488).withValues(alpha: 0.25), blurRadius: 4, offset: const Offset(0, 2))]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      !isGrocery ? Icons.check_circle_rounded : Icons.phone_android_rounded,
                      size: 16,
                      color: !isGrocery ? Colors.white : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'موبائل سپلائر پورٹل',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: !isGrocery ? Colors.white : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}