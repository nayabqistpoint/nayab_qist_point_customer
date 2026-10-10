import 'package:flutter/material.dart';

class WalletMasterCardUi extends StatelessWidget {
  final int net;
  final bool isDebtor;
  final int totalInstallmentDue;
  final int cashLoanBalance;
  final int pendingServiceCredit;
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. اوپر والا ٹائٹل اور بیج رو (Flexible تاکہ اوور فلو نہ ہو)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined, size: 16, color: Color(0xFF64748B)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        isDebtor ? 'کل خالص واجب الادا رقم' : 'آپ کی پیشگی جمع رقم',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDebtor ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isDebtor ? const Color(0xFFFECACA) : const Color(0xFFBBF7D0),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDebtor ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isDebtor ? 'واجب الادا' : 'ایڈوانس جمع',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: isDebtor ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 2. مرکزی بڑی رقم
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  formatAmount(net.abs()),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: isDebtor ? const Color(0xFFDC2626) : const Color(0xFF059669),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Rs.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDebtor ? const Color(0xFFDC2626) : const Color(0xFF059669),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),
          const Text(
            'اقساط بقایا اور نقد ادھار کا مجموعی خالص میزان',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}