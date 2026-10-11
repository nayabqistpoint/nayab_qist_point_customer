import 'package:flutter/material.dart';

class PrivacyShieldCardUi extends StatelessWidget {
  final String title;
  final String description;

  const PrivacyShieldCardUi({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(color: Color(0xFF16A34A), shape: BoxShape.circle),
            child: const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: Color(0xFF14532D)),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 10.5, color: Color(0xFF166534), height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}