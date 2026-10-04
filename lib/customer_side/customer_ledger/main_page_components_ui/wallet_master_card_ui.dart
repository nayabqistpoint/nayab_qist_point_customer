import 'package:flutter/material.dart';

class WalletMasterCardUi extends StatelessWidget {
  final int net;
  final bool isDebtor;
  final int totalInstallmentDue;
  final int cashLoanBalance;
  final int pendingServiceCredit; // 🎯 اب یہ زیرِ جائزہ کلیم بل ہیں
  final String Function(int) formatAmount;

  const WalletMasterCardUi({
    super.key,
    required this.net,
    required this.isDebtor,
    required this.totalInstallmentDue,
    required this.cashLoanBalance,
    required this.pendingServiceCredit,
    required this.formatAmount,
  });

  @override
  Widget build(BuildContext context) {
    // اگر کسٹمر نے نقد ادھار زائد دیا ہوا ہے تو وہ ایڈوانس (کریڈٹ) مانا جائے گا
    final bool isLoanInCredit = cashLoanBalance < 0;

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
          // اوپر کا ہیڈر: عنوان اور اسٹیٹس پل
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
                        isDebtor ? 'کل خالص واجب الادا رقم:' : 'کل خالص کسٹمر کریڈٹ:',
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

          // مین بقایا رقم (صاف ستھری اور واضح)
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
            'اقساط بقایا اور نقد ادھار کا مجموعی خالص میزان',
            style: TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFCBD5E1), thickness: 1.3),
          ),

          // نیچے کی 3 چپس (اقساط واجب + نقد قرض + زیرِ جائزہ بل)
          Row(
            children: [
              // ۱. اقساط واجب (ہمیشہ سرخ قرض)
              Expanded(
                child: _summaryChipDark(
                  'اقساط واجب',
                  'Rs. ${formatAmount(totalInstallmentDue)}',
                  const Color(0xFFDC2626),
                ),
              ),
              const SizedBox(width: 6),

              // ۲. نقد قرض (اگر مثبت ہے تو سرخ قرض، اگر منفی ہے تو سبز ایڈوانس)
              Expanded(
                child: _summaryChipDark(
                  isLoanInCredit ? 'نقد ایڈوانس' : 'نقد ادھار',
                  '${isLoanInCredit ? '-' : ''}Rs. ${formatAmount(cashLoanBalance.abs())}',
                  isLoanInCredit ? const Color(0xFF059669) : const Color(0xFFDC2626),
                ),
              ),
              const SizedBox(width: 6),

              // ۳. زیرِ جائزہ راشن / سروس بل (معلوماتی چپ، پیلے/امبر رنگ میں)
              Expanded(
                child: _summaryChipDark(
                  'زیرِ جائزہ بل',
                  'Rs. ${formatAmount(pendingServiceCredit)}',
                  const Color(0xFFD97706), // امبر کلر برائے پینڈنگ ریویو
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