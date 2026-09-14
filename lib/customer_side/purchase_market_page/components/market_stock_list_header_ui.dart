import 'package:flutter/material.dart';

class MarketStockListHeaderUi extends StatelessWidget {
  final int totalCount;

  const MarketStockListHeaderUi({super.key, required this.totalCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'دکان پر دستیاب موبائل فونز',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$totalCount ماڈلز موجود',
            style: const TextStyle(fontSize: 10.5, color: Color(0xFF475569), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}