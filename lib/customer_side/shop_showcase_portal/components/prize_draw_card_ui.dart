import 'package:flutter/material.dart';

class PrizeDrawCardUi extends StatelessWidget {
  final String title;
  final String description;

  const PrizeDrawCardUi({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(color: Color(0xFFD97706), shape: BoxShape.circle),
            child: const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: Color(0xFF78350F)),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(fontSize: 10.5, color: Color(0xFF92400E), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}