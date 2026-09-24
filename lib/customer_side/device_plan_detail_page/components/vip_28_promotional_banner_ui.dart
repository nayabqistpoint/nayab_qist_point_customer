import 'package:flutter/material.dart';

class Vip28PromotionalBannerUi extends StatelessWidget {
  final int totalCount;
  final int durationCount;

  const Vip28PromotionalBannerUi({
    super.key,
    required this.totalCount,
    required this.durationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFDE68A).withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFFDE68A),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$totalCount',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نایاب $totalCount اقساطی پیکجز کا مکمل جدول',
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: Color(0xFFFDE68A)),
                ),
                const SizedBox(height: 1),
                Text(
                  '$durationCount مدتیں • آسان چیک و اشٹام پلانز • زیرو ایڈوانس سہولت',
                  style: const TextStyle(fontSize: 9.5, color: Colors.white70, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}