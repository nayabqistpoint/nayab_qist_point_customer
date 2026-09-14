import 'package:flutter/material.dart';
import '../universal_payment_controller.dart';

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

    return Column(
      children: [
        // حسابی توازن پٹی
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isReconciled ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isReconciled ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isReconciled
                      ? '✔ تمام سورسز کی رقم مکمل برابر ہے'
                      : '✖ فرق: Rs. ${controller.formatAmount(controller.difference.abs())} (${controller.difference < 0 ? 'رقم کم ہے' : 'رقم زائد ہے'})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: isReconciled ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'سورسز: Rs. ${controller.formatAmount(controller.splitsSum)} / ہدف: Rs. ${controller.formatAmount(controller.requiredCashFromSources)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isReconciled ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // حتمی تصدیق بٹن
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: isReconciled ? onSubmit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFF94A3B8),
              elevation: isReconciled ? 4 : 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              isReconciled ? 'ادائیگی حتمی تصدیق کے لیے بھیجیں' : 'پہلے سورسز اور رعایت کا حساب برابر کریں',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}