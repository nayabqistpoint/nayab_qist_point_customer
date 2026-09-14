import 'package:flutter/material.dart';

class IndividualPlanRowUi extends StatelessWidget {
  final Map<String, dynamic> plan;
  final VoidCallback onOrderTap;

  const IndividualPlanRowUi({
    super.key,
    required this.plan,
    required this.onOrderTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCheque = plan['guarantee'] == 'BANK_CHEQUE';
    final bool hasAdv = plan['hasAdvance'] as bool;
    final int advance = plan['advance'] as int;
    final int monthly = plan['monthly'] as int;
    final int months = plan['months'] as int;
    final int totalContractPrice = advance + (monthly * months);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCheque ? const Color(0xFFA7F3D0) : const Color(0xFFC7D2FE),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCheque ? const Color(0xFFECFDF5) : const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: isCheque ? const Color(0xFFA7F3D0) : const Color(0xFFC7D2FE),
              ),
            ),
            child: Icon(
              isCheque ? Icons.account_balance_rounded : Icons.balance_rounded,
              size: 19,
              color: isCheque ? const Color(0xFF059669) : const Color(0xFF3730A3),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 3,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '$months ماہ کی مدت',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: Text(
                        'کل: Rs. $totalContractPrice',
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF065F46),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: isCheque ? const Color(0xFFDCFCE7) : const Color(0xFFE0E7FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isCheque ? 'بینک چیک' : 'اشٹام پرنوٹ',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: isCheque ? const Color(0xFF047857) : const Color(0xFF3730A3),
                        ),
                      ),
                    ),
                    const Text('•', style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 10)),
                    Text(
                      hasAdv ? 'ایڈوانس: Rs. $advance' : '⭐ بغیر ایڈوانس',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: hasAdv ? const Color(0xFFB45309) : const Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Rs. $monthly',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0D9488),
                ),
              ),
              const Text(
                'ماہانہ قسط',
                style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: onOrderTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text(
                  'آرڈر شیڈول',
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}