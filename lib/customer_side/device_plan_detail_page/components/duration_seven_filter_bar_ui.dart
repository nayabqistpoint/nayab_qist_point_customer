import 'package:flutter/material.dart';

class DurationSevenFilterBarUi extends StatelessWidget {
  final int selectedDuration;
  final Function(int) onSelect;

  const DurationSevenFilterBarUi({
    super.key,
    required this.selectedDuration,
    required this.onSelect,
  });

  Widget _chip(String label, int value) {
    final active = selectedDuration == value;
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: () => onSelect(value),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: active ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: active ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip('تمام 7 مدتیں', 0),
          _chip('6 ماہ', 6),
          _chip('7 ماہ', 7),
          _chip('8 ماہ', 8),
          _chip('9 ماہ', 9),
          _chip('10 ماہ', 10),
          _chip('11 ماہ', 11),
          _chip('12 ماہ', 12),
        ],
      ),
    );
  }
}