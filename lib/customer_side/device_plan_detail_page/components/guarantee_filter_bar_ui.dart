import 'package:flutter/material.dart';

class GuaranteeFilterBarUi extends StatelessWidget {
  final String selectedFilter;
  final int totalCount;
  final int chequeCount;
  final int stampCount;
  final Function(String) onSelect;

  const GuaranteeFilterBarUi({
    super.key,
    required this.selectedFilter,
    required this.totalCount,
    required this.chequeCount,
    required this.stampCount,
    required this.onSelect,
  });

  Widget _chip(String label, String value) {
    final active = selectedFilter == value;
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
          _chip('سبھی ضمانتیں ($totalCount)', 'ALL'),
          if (chequeCount > 0) _chip('🏦 بینک چیک گارنٹی ($chequeCount)', 'BANK_CHEQUE'),
          if (stampCount > 0) _chip('⚖️ قانونی اشٹام و پرنوٹ ($stampCount)', 'LEGAL_STAMP'),
        ],
      ),
    );
  }
}