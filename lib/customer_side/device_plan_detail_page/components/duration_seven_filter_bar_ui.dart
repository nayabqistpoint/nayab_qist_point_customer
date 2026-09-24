import 'package:flutter/material.dart';

class DurationSevenFilterBarUi extends StatelessWidget {
  final int selectedDuration;
  final List<int> allowedDurations;
  final Function(int) onSelect;

  const DurationSevenFilterBarUi({
    super.key,
    required this.selectedDuration,
    required this.allowedDurations,
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
            border: Border.all(
              color: active ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
            ),
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
          _chip('تمام مدتیں', 0),
          ...allowedDurations.map(
            (duration) => _chip('$duration ماہ', duration),
          ),
        ],
      ),
    );
  }
}