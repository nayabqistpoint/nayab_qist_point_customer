import 'package:flutter/material.dart';

class ProductsWingsCardUi extends StatelessWidget {
  final int plansCount;

  const ProductsWingsCardUi({
    super.key,
    required this.plansCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'شاپ شیڈول پالیسی و کیٹیگریز',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBAE6FD)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.phone_iphone_rounded, color: Color(0xFF0284C7), size: 16),
                        SizedBox(width: 4),
                        Text('اسمارٹ فونز', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '• ماہانہ کوٹہ: 10 موبائلز\n• سلیکشن شاپ پر $plansCount پلانز سے\n• ایڈوانس و قسط خود طے کریں',
                      style: const TextStyle(fontSize: 10, color: Color(0xFF475569), height: 1.45),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFED7AA)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.blender_rounded, color: Color(0xFFEA580C), size: 16),
                        SizedBox(width: 4),
                        Text('چھوٹے الیکٹرانکس', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      '• جوسر، استری، واشنگ مشین\n• کوئی سلاٹ ویٹنگ نہیں!\n• درخواست پر 24 گھنٹے میں تیار',
                      style: TextStyle(fontSize: 10, color: Color(0xFF475569), height: 1.45),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}