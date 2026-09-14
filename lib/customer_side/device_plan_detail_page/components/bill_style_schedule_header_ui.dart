import 'package:flutter/material.dart';

class BillStyleScheduleHeaderUi extends StatelessWidget {
  final int count;

  const BillStyleScheduleHeaderUi({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 👈 دائیں/بائیں جگہ خودکار سمیٹنے کے لیے Expanded
        const Expanded(
          child: Text(
            'اقساطی پلانز کا شیڈول جدول:',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF0D9488).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$count پیکجز ظاہر ہیں',
            style: const TextStyle(
              fontSize: 10.5,
              color: Color(0xFF0D9488),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}