import 'package:flutter/material.dart';

class WalletMasterCardUi extends StatelessWidget {
  final int net;
  final bool isDebtor;
  final int totalInstallmentDue;
  final int cashLoanBalance;
  final int approvedServiceCredit;
  final String Function(int) formatAmount;

  const WalletMasterCardUi({
    super.key,
    required this.net,
    required this.isDebtor,
    required this.totalInstallmentDue,
    required this.cashLoanBalance,
    required this.approvedServiceCredit,
    required this.formatAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Color(0xFF0D9488),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        isDebtor ? 'کل واجب الادا رقم:' : 'کل کریڈٹ بیلنس:',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildRefinedOutlinedPill(isDebtor),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'Rs. ',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDebtor ? const Color(0xFFDC2626) : const Color(0xFF059669),
                  ),
                ),
                Text(
                  formatAmount(net.abs()),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: isDebtor ? const Color(0xFFDC2626) : const Color(0xFF059669),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'اقساط اور نقد قرض میں سے صرف منظور شدہ بل منہا ہوتا ہے',
            style: TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFCBD5E1), thickness: 1.3),
          ),
          Row(
            children: [
              Expanded(
                child: _summaryChipDark(
                  'اقساط واجب',
                  'Rs. ${formatAmount(totalInstallmentDue)}',
                  const Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _summaryChipDark(
                  'نقد قرض',
                  'Rs. ${formatAmount(cashLoanBalance)}',
                  const Color(0xFFDC2626),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _summaryChipDark(
                  'منظور بل',
                  '- Rs. ${formatAmount(approvedServiceCredit)}',
                  const Color(0xFF0D9488),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRefinedOutlinedPill(bool isDebtor) {
    final Color textColor = isDebtor ? const Color(0xFFDC2626) : const Color(0xFF059669);
    final Color borderColor = isDebtor ? const Color(0xFFFECACA) : const Color(0xFFA7F3D0);
    final Color dotColor = isDebtor ? const Color(0xFFEF4444) : const Color(0xFF10B981);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            isDebtor ? 'ذمہ داری قرض' : 'آپ کا ایڈوانس',
            style: TextStyle(
              fontSize: 10,
              color: textColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryChipDark(String title, String val, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            val,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ],
    );
  }
}