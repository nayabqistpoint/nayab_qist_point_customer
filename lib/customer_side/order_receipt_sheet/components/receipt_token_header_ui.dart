import 'package:flutter/material.dart';

class ReceiptTokenHeaderUi extends StatelessWidget {
  final String tokenNo;

  const ReceiptTokenHeaderUi({super.key, required this.tokenNo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'نایاب قسط پوائنٹ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
              ),
              Text(
                'رسید ٹوکن: $tokenNo',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.hourglass_top_rounded, size: 10, color: Color(0xFFFDE68A)),
              SizedBox(width: 4),
              Text(
                'زیرِ جائزہ (Pending)',
                style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFFFDE68A)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}