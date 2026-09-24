import 'package:flutter/material.dart';

class CustomEstimateHeroCardUi extends StatelessWidget {
  final String title;
  final int baseValue;
  final int displayedAdvance;

  const CustomEstimateHeroCardUi({
    super.key,
    required this.title,
    required this.baseValue,
    required this.displayedAdvance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const Divider(height: 18, color: Color(0xFF334155)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('تخمینہ رقم: Rs. $baseValue', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFFFDE68A))),
              Text(
                displayedAdvance > 0 ? 'ایڈوانس: Rs. $displayedAdvance' : '⭐ بغیر ایڈوانس پلان',
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF34D399)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}