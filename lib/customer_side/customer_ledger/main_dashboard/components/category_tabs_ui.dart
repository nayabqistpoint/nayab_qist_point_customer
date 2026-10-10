import 'package:flutter/material.dart';

class CategoryTabsUi extends StatelessWidget {
  final int selectedTabIndex;
  final int totalInstallmentDue;
  final int cashLoanBalance;
  final int? approvedServiceCredit;
  final String Function(int) formatAmount;
  final ValueChanged<int> onTabSelected;

  const CategoryTabsUi({
    super.key,
    required this.selectedTabIndex,
    required this.totalInstallmentDue,
    required this.cashLoanBalance,
    this.approvedServiceCredit,
    required this.formatAmount,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // کلین سافٹ بیک گراؤنڈ
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          // 📱 ٹیب 1: اقساط کھاتہ
          Expanded(
            child: _buildTab(
              index: 0,
              title: 'اقساط کھاتہ',
              amount: 'Rs. ${formatAmount(totalInstallmentDue)}',
              icon: Icons.phone_android_rounded,
              isSelected: selectedTabIndex == 0,
            ),
          ),
          const SizedBox(width: 8),
          // 💵 ٹیب 2: نقد کھاتہ
          Expanded(
            child: _buildTab(
              index: 1,
              title: 'نقد کھاتہ',
              amount: 'Rs. ${formatAmount(cashLoanBalance.abs())}',
              icon: Icons.account_balance_wallet_rounded,
              isSelected: selectedTabIndex == 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required int index,
    required String title,
    required String amount,
    required IconData icon,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => onTabSelected(index),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          // منتخب شدہ اصل گہرا کلاسک بلیک اور غیر منتخب خالص سفید کارڈ
          color: isSelected ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF0F172A).withValues(alpha: 0.22)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: isSelected ? 6 : 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // عنوان اور آئیکن (چھوٹا اور متوازن)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: isSelected ? const Color(0xFF2DD4BF) : const Color(0xFF475569),
                ),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.5, // عنوان کا سائز بالکل متوازن
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF334155),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // رقوم کے ہندسے (بڑے، نمایاں اور بولڈ)
            Text(
              amount,
              style: TextStyle(
                fontSize: 17, // رقوم کے ہندسے بڑے اور واضح
                fontWeight: FontWeight.w900,
                letterSpacing: 0.2,
                color: isSelected ? const Color(0xFFFDE68A) : const Color(0xFF0D9488),
              ),
            ),
          ],
        ),
      ),
    );
  }
}