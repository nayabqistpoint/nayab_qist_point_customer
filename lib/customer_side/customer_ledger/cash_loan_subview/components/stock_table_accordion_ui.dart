import 'package:flutter/material.dart';

class StockTableAccordionUi extends StatelessWidget {
  final Map<String, dynamic> entry;
  final String Function(int) formatAmount;

  const StockTableAccordionUi({
    super.key,
    required this.entry,
    required this.formatAmount,
  });

  @override
  Widget build(BuildContext context) {
    final List stocks = (entry['stockItems'] as List?) ?? [];

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
                'سپلائر موبائل لاٹ برائے دکان انوینٹری:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
              ),
              Text(
                'لاگت رقم ادھار سے کٹوتی',
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
                  decoration: const BoxDecoration(color: Color(0xFFEFF6FF)),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                      child: Text('موبائل ماڈل', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                      child: Text('ریم / میموری', textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                      child: Text('کنڈیشن / وارنٹی', textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                      child: Text('لاگت رقم', textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
                    ),
                  ],
                ),
                ...stocks.map((stock) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: Text(stock['model'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: Text(stock['specs'] ?? '', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: Column(
                        children: [
                          Text(stock['condition'] ?? '', style: const TextStyle(fontSize: 11.5, color: Color(0xFF0F766E), fontWeight: FontWeight.bold)),
                          Text(stock['warranty'] ?? '', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: Text(
                        'Rs. ${formatAmount(stock['cost'] ?? 0)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
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