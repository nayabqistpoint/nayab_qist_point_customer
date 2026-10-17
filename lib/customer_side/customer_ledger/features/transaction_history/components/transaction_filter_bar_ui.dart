import 'package:flutter/material.dart';

class TransactionFilterBarUi extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onFilterSelected;

  const TransactionFilterBarUi({
    super.key,
    required this.selectedIndex,
    required this.onFilterSelected,
  });

  static const List<String> filters = [
    'تمام رسیدیں',
    'اقساط کھاتہ',
    'نقد کھاتہ',
    'زیرِ جائزہ ⏳',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(filters.length, (index) {
          final isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ChoiceChip(
              label: Text(
                filters[index],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF334155),
                ),
              ),
              selected: isSelected,
              selectedColor: const Color(0xFF0F172A),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFCBD5E1),
                ),
              ),
              onSelected: (_) => onFilterSelected(index),
            ),
          );
        }),
      ),
    );
  }
}