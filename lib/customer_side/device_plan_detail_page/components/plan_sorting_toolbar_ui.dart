import 'package:flutter/material.dart';

class PlanSortingToolbarUi extends StatelessWidget {
  final String activeSort;
  final Function(String) onSortChanged;

  const PlanSortingToolbarUi({
    super.key,
    required this.activeSort,
    required this.onSortChanged,
  });

  Widget _sortChip({
    required String label,
    required String sortKey,
    required IconData icon,
  }) {
    final bool isSelected = activeSort == sortKey;
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: () => onSortChanged(sortKey),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFCBD5E1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 13,
                color: isSelected ? const Color(0xFFFDE68A) : const Color(0xFF64748B),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const Text(
            'ترتیب:',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _sortChip(
                    label: 'سب سے کم قسط',
                    sortKey: 'LOW_MONTHLY',
                    icon: Icons.trending_down_rounded,
                  ),
                  _sortChip(
                    label: 'تیز ترین اختتام (کم مدت)',
                    sortKey: 'SHORTEST_DURATION',
                    icon: Icons.bolt_rounded,
                  ),
                  _sortChip(
                    label: 'سب سے سستا کل معاہدہ',
                    sortKey: 'LOWEST_TOTAL',
                    icon: Icons.savings_outlined,
                  ),
                  _sortChip(
                    label: 'معیاری (پہلے کم مدت)',
                    sortKey: 'DEFAULT',
                    icon: Icons.tune_rounded,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}