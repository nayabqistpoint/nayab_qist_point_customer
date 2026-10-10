import 'package:flutter/material.dart';

class GroceryTableAccordionUi extends StatelessWidget {
  final Map<String, dynamic> entry;
  final String Function(int) formatAmount;

  const GroceryTableAccordionUi({
    super.key,
    required this.entry,
    required this.formatAmount,
  });

  @override
  Widget build(BuildContext context) {
    final List items = (entry['items'] as List?) ?? [];

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
            children: const [
              Text(
                'تفصیلات راشن اشیاء (گروسری):',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
              ),
              Text(
                'خالص نقد کٹوتی',
                style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Table(
              border: TableBorder.all(color: const Color(0xFFCBD5E1), width: 1.0),
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFFF0FDFA)),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                      child: Text('آئٹم نام', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                      child: Text('مقدار', textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                      child: Text('ریٹ', textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                      child: Text('کل رقم', textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                    ),
                  ],
                ),
                ...items.map((item) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: Text(item['name'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: Text(item['qty'] ?? '', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: Text('Rs. ${item['rate']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: Text(
                        'Rs. ${formatAmount(item['amount'] ?? 0)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}