import 'package:flutter/material.dart';
import '../cash_loan_section_controller.dart';
import 'cash_loan_balance_summary_ui.dart';
import 'cash_loan_accordion_card_ui.dart';

class CashLoanSectionUi extends StatelessWidget {
  final CashLoanSectionController controller;
  final VoidCallback onTransferPressed;
  final VoidCallback onRepaymentPressed;
  final VoidCallback onGroceryPressed;
  final VoidCallback onStockPressed;

  const CashLoanSectionUi({
    super.key,
    required this.controller,
    required this.onTransferPressed,
    required this.onRepaymentPressed,
    required this.onGroceryPressed,
    required this.onStockPressed,
  });

  @override
  Widget build(BuildContext context) {
    final computedList = controller.computedEntries;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CashLoanBalanceSummaryUi(
          cashLoanBalance: controller.cashLoanBalance,
          formatAmount: controller.formatAmount,
          onTransferPressed: onTransferPressed,
          onRepaymentPressed: onRepaymentPressed,
          onGroceryPressed: onGroceryPressed,
          onStockPressed: onStockPressed,
        ),
        const SizedBox(height: 18),
        const Text(
          'نقد کھاتہ ریکارڈ و تفصیلات (تاریخ وار رننگ بیلنس):',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 12),
        ...computedList.asMap().entries.map((item) {
          final index = item.key;
          final entry = item.value;
          final isExpanded = controller.expandedIndices.contains(index);

          return CashLoanAccordionCardUi(
            entry: entry,
            isExpanded: isExpanded,
            onToggle: () => controller.toggleAccordion(index),
            formatAmount: controller.formatAmount,
          );
        }),
      ],
    );
  }
}