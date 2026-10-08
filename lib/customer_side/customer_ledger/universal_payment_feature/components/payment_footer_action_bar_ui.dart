// lib/customer_side/universal_payments/universal_payment_components_ui/payment_footer_action_bar_ui.dart

import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/universal_payment_feature/universal_payment_controller.dart';

class PaymentFooterActionBarUi extends StatelessWidget {
  final UniversalPaymentController controller;
  final VoidCallback onSubmit;

  const PaymentFooterActionBarUi({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final bool isReconciled = controller.isReconciled;
    final int diff = controller.discrepancy;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isReconciled ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isReconciled ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'نقد و بینک وصولی: Rs. ${controller.formatAmount(controller.splitsSum)}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF334155),
                ),
              ),
              Text(
                isReconciled
                    ? 'حساب مکمل برابر ہے ✓'
                    : diff > 0
                        ? 'Rs. ${controller.formatAmount(diff)} زائد ہیں'
                        : 'Rs. ${controller.formatAmount(diff.abs())} کم ہیں',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isReconciled ? const Color(0xFF059669) : const Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: isReconciled ? onSubmit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              disabledBackgroundColor: const Color(0xFF94A3B8).withValues(alpha: 0.4),
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white70,
              elevation: isReconciled ? 2 : 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isReconciled ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  isReconciled
                      ? 'ادائیگی حتمی تصدیق کے لیے بھیجیں'
                      : 'پہلے سورسز اور رعایت کا حساب برابر کریں',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}