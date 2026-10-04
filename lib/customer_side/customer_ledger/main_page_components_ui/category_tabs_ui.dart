import 'package:flutter/material.dart';

class CategoryTabsUi extends StatelessWidget {
  final int selectedTabIndex;
  final int totalInstallmentDue;
  final int cashLoanBalance;
  final int approvedServiceCredit;
  final String Function(int) formatAmount;
  final ValueChanged<int> onTabSelected;

  const CategoryTabsUi({
    super.key,
    required this.selectedTabIndex,
    required this.totalInstallmentDue,
    required this.cashLoanBalance,
    required this.approvedServiceCredit,
    required this.formatAmount,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        children: [
          _categoryTab(0, 'اقساط کھاتہ', 'Rs. ${formatAmount(totalInstallmentDue)}'),
          _categoryTab(1, 'نقد دستی ادھار', 'Rs. ${formatAmount(cashLoanBalance)}'),
          _categoryTab(2, 'خدمات و راشن', '- Rs. ${formatAmount(approvedServiceCredit)}'),
        ],
      ),
    );
  }

  Widget _categoryTab(int index, String title, String badge) {
    final bool isSel = selectedTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(index),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSel ? const Color(0xFF1E293B) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSel ? Colors.white : const Color(0xFF334155))),
              const SizedBox(height: 3),
              Text(badge, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: isSel ? const Color(0xFFFDE68A) : const Color(0xFF64748B))),
            ],
          ),
        ),
      ),
    );
  }
}