import 'package:flutter/material.dart';

class ActiveOrderSummaryCardUi extends StatelessWidget {
  final String itemName;
  final int totalContract;
  final int totalPaid;
  final int totalRemaining;
  final int totalMonths;
  final String Function(int) formatAmount;

  const ActiveOrderSummaryCardUi({
    super.key,
    required this.itemName,
    required this.totalContract,
    required this.totalPaid,
    required this.totalRemaining,
    required this.totalMonths,
    required this.formatAmount,
  });

  @override
  Widget build(BuildContext context) {
    final double paidRatio = totalContract > 0
        ? (totalPaid / totalContract).clamp(0.0, 1.0)
        : 0.0;
    final int overallPercent = (paidRatio * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ऊपरी पंक्ति: डिवाइस नाम, प्लान अवधि और कुल रिकवरी प्रतिशत
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.phone_android_rounded, size: 14, color: Color(0xFF0D9488)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '$itemName ($totalMonths ماہ پلان)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: overallPercent == 100
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: overallPercent == 100
                        ? const Color(0xFF86EFAC)
                        : const Color(0xFFBFDBFE),
                  ),
                ),
                child: Text(
                  'ریکوری: $overallPercent%',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: overallPercent == 100
                        ? const Color(0xFF16A34A)
                        : const Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // निचली पट्टी: कुल बिल, अदा शुदा, और कुल बकाया
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                // 1. कुल अनुबंध बिल
                Expanded(
                  child: _metricColumn(
                    title: 'کل بل',
                    value: 'Rs. ${formatAmount(totalContract)}',
                    color: const Color(0xFF475569),
                  ),
                ),
                Container(width: 1, height: 22, color: const Color(0xFFE2E8F0)),

                // 2. कुल अदा शुदा
                Expanded(
                  child: _metricColumn(
                    title: 'کل ادا شدہ',
                    value: 'Rs. ${formatAmount(totalPaid)}',
                    color: const Color(0xFF059669),
                  ),
                ),
                Container(width: 1, height: 22, color: const Color(0xFFE2E8F0)),

                // 3. कुल बकाया (इस मोबाइल का)
                Expanded(
                  child: _metricColumn(
                    title: 'کل بقایا',
                    value: 'Rs. ${formatAmount(totalRemaining)}',
                    color: totalRemaining > 0
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF059669),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricColumn({
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 1),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}