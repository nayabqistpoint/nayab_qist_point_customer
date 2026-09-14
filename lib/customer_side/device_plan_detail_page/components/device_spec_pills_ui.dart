import 'package:flutter/material.dart';

class DeviceSpecPillsUi extends StatelessWidget {
  final String ramRom;
  final String condition;
  final String warranty;

  const DeviceSpecPillsUi({
    super.key,
    required this.ramRom,
    required this.condition,
    required this.warranty,
  });

  Widget _badgeChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF475569)),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _badgeChip(Icons.memory_rounded, ramRom),
        _badgeChip(Icons.verified_rounded, condition),
        _badgeChip(Icons.security_rounded, warranty),
      ],
    );
  }
}