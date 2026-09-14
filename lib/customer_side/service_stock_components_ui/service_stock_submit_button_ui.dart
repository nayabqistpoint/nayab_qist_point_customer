import 'package:flutter/material.dart';
import '../service_stock_controller.dart';

class ServiceStockSubmitButtonUi extends StatelessWidget {
  final ServiceStockController controller;

  const ServiceStockSubmitButtonUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isReconciled = controller.isExpenseReconciled;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isReconciled
            ? () {
                final payload = controller.getSubmitPayload();
                if (payload != null) {
                  Navigator.pop(context, payload);
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D9488),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF94A3B8),
          elevation: isReconciled ? 4 : 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          isReconciled
              ? 'بل جمع کریں (کل رقم: Rs. ${controller.formatAmount(controller.totalBill)})'
              : 'پہلے ایکسپنس کیٹیگریز کا حساب برابر کریں',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}