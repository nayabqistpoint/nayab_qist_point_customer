import 'package:flutter/material.dart';

class CashRepaymentAccordionUi extends StatelessWidget {
  final Map<String, dynamic> entry;
  final String Function(int) formatAmount;

  const CashRepaymentAccordionUi({
    super.key,
    required this.entry,
    required this.formatAmount,
  });

  @override
  Widget build(BuildContext context) {
    final List splits = (entry['splits'] as List?) ?? [];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'رسید نمبر: ${entry['receiptNo'] ?? '-'}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
              ),
              if ((entry['discount'] ?? 0) > 0)
                Text(
                  'خصوصی رعایت (ڈسکاؤنٹ): Rs. ${formatAmount(entry['discount'])}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.bold),
                ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'ادائیگی ذرائع کی تقسیم (Payment Sources):',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Table(
              border: TableBorder.all(color: const Color(0xFFCBD5E1), width: 1.0),
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Text('ذریعہ ادائیگی (اکاؤنٹ / کیش)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Text('ادا شدہ رقم', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                if (splits.isNotEmpty)
                  ...splits.map((s) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(s['source'] ?? '-', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'Rs. ${formatAmount(s['amount'] ?? 0)}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                        ),
                      ),
                    ],
                  ))
                else
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(entry['method'] ?? 'دکان کاؤنٹر کیش', style: const TextStyle(fontSize: 11.5)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'Rs. ${formatAmount(entry['amount'] ?? 0)}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}