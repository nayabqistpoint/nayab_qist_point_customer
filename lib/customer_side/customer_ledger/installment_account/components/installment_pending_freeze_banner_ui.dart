import 'package:flutter/material.dart';

class InstallmentPendingFreezeBannerUi extends StatelessWidget {
  final int pendingAmount;
  final String Function(int) formatAmount;

  const InstallmentPendingFreezeBannerUi({
    super.key,
    required this.pendingAmount,
    required this.formatAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFCD34D), width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFFD97706), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'آپ کی پچھلی ادائیگی (Rs. ${formatAmount(pendingAmount)}) ایڈمن کی زیرِ تصدیق ہے۔ اس کھاتے پر تصدیق تک مزید ادائیگی مقفل ہے۔',
              style: const TextStyle(
                fontSize: 10.8,
                color: Color(0xFF92400E),
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}