import 'package:flutter/material.dart';

class WalletMasterCardUi extends StatelessWidget {
  final int netAmount;
  final bool isDebtor;
  final String Function(int) formatAmount;

  const WalletMasterCardUi({
    super.key,
    required this.netAmount,
    required this.isDebtor,
    required this.formatAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDebtor
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFF064E3B), const Color(0xFF022C22)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDebtor ? const Color(0xFF334155) : const Color(0xFF10B981).withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.account_balance_wallet_rounded, size: 16, color: Color(0xFFFDE68A)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isDebtor ? 'کل خالص واجب الادا میزان' : 'آپ کی پیشگی جمع رقم (ایڈوانس)',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFFE2E8F0)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDebtor ? const Color(0xFFDC2626) : const Color(0xFF059669),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isDebtor ? 'واجب الادا' : 'ایڈوانس',
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                'Rs. ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFDE68A)),
              ),
              Text(
                formatAmount(netAmount.abs()),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'اقساط کھاتہ اور نقد کھاتہ کا مجموعی بقایا (فائر اسٹور لائیو سنک)',
            style: TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}