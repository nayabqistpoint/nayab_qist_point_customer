import 'package:flutter/material.dart';

class CashAccountGatewayCardUi extends StatelessWidget {
  final int balance;
  final bool hasAdvance;
  final String Function(int) formatAmount;
  final VoidCallback onTap;

  const CashAccountGatewayCardUi({
    super.key,
    required this.balance,
    required this.hasAdvance,
    required this.formatAmount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDFA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF99F6E4)),
                          ),
                          child: const Icon(Icons.payments_rounded, size: 24, color: Color(0xFF0F766E)),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'نقد کھاتہ',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'دستی لین دین و نقد تفصیلات',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          hasAdvance ? 'دستیاب ایڈوانس' : 'واجب نقد رقم',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                        ),
                        Text(
                          '${hasAdvance ? '-' : ''}Rs. ${formatAmount(balance.abs())}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: hasAdvance ? const Color(0xFF059669) : const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: hasAdvance ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: hasAdvance ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        hasAdvance ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                        size: 15,
                        color: hasAdvance ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          hasAdvance
                              ? 'سبز ایڈوانس رقم موجود ہے جسے اقساط میں ایڈجسٹ کیا جا سکتا ہے۔'
                              : 'خالص نقد ادھار واجب الادا بیلنس ہے۔',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: hasAdvance ? const Color(0xFF166534) : const Color(0xFF991B1B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'اس کھاتے میں نقد لین دین کا رننگ بیلنس اور تصدیق شدہ رسیدیں شامل ہیں۔',
                  style: TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          InkWell(
            onTap: onTap,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'نقد کھاتہ پاس بک و ٹرانزیکشنز کھولیں',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_back_rounded, size: 16, color: Color(0xFF0F766E)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}