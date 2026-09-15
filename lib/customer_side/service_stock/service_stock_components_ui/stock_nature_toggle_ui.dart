import 'package:flutter/material.dart';
import '../service_stock_controller.dart';

class StockNatureToggleUi extends StatelessWidget {
  final ServiceStockController controller;

  const StockNatureToggleUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isStockBarter = controller.isStockBarter;

    return Row(
      children: [
        // 🎯 1. دکان و راشن خرچہ بٹن
        Expanded(
          child: InkWell(
            onTap: () => controller.setNatureIndex(0),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
              decoration: BoxDecoration(
                color: !isStockBarter ? const Color(0xFF0D9488) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: !isStockBarter ? const Color(0xFF0D9488) : const Color(0xFFCBD5E1),
                  width: 1.2,
                ),
                boxShadow: !isStockBarter
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0D9488).withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    !isStockBarter ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                    size: 14,
                    color: !isStockBarter ? Colors.white : const Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'دکان و راشن خرچہ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: !isStockBarter ? Colors.white : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // 🎯 2. اسٹاک تبادلہ (موبائل) بٹن
        Expanded(
          child: InkWell(
            onTap: () => controller.setNatureIndex(1),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
              decoration: BoxDecoration(
                color: isStockBarter ? const Color(0xFF0D9488) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isStockBarter ? const Color(0xFF0D9488) : const Color(0xFFCBD5E1),
                  width: 1.2,
                ),
                boxShadow: isStockBarter
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0D9488).withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isStockBarter ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                    size: 14,
                    color: isStockBarter ? Colors.white : const Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'اسٹاک تبادلہ (موبائل)',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: isStockBarter ? Colors.white : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}