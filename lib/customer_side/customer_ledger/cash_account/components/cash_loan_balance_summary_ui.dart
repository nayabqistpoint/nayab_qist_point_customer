import 'package:flutter/material.dart';

class CashLoanBalanceSummaryUi extends StatelessWidget {
  final int cashLoanBalance;
  final String Function(int) formatAmount;
  final VoidCallback onTransferPressed;
  final VoidCallback onRepaymentPressed;
  final VoidCallback onGroceryPressed;
  final VoidCallback onStockPressed;

  const CashLoanBalanceSummaryUi({
    super.key,
    required this.cashLoanBalance,
    required this.formatAmount,
    required this.onTransferPressed,
    required this.onRepaymentPressed,
    required this.onGroceryPressed,
    required this.onStockPressed,
  });

  @override
  Widget build(BuildContext context) {
    // 🌟 بنیادی سیکیورٹی بیریئر: صرف اس وقت ایڈوانس مانا جائے گا جب بیلنس منفی ہو
    final bool hasGreenAdvance = cashLoanBalance < 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
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
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasGreenAdvance ? 'پیشگی جمع رقم (سبز ایڈوانس):' : 'خالص نقد ادھار واجب الادا:',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${hasGreenAdvance ? '-' : ''}Rs. ${formatAmount(cashLoanBalance.abs())}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: hasGreenAdvance ? const Color(0xFF059669) : const Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ],
              ),
              // 🔒 حفاظتی بٹن: اگر نقد رقم جمع نہیں ہے تو بٹن لاک رہے گا
              Tooltip(
                message: hasGreenAdvance ? 'ایڈوانس سے قسط کلیئر کریں' : 'قسط میں ایڈجسٹمنٹ کے لیے پہلے نقد ایڈوانس ہونا ضروری ہے',
                child: ElevatedButton.icon(
                  onPressed: hasGreenAdvance ? onTransferPressed : null,
                  icon: const Icon(Icons.sync_alt_rounded, size: 14),
                  label: const Text('قسط میں ایڈجسٹ کریں', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasGreenAdvance ? const Color(0xFF0F766E) : const Color(0xFF94A3B8),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFE2E8F0),
                    disabledForegroundColor: const Color(0xFF94A3B8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: hasGreenAdvance ? 1 : 0,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: OutlinedButton(
                    onPressed: onRepaymentPressed,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1E293B),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('نقد ادائیگی', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: OutlinedButton(
                    onPressed: onGroceryPressed,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0D9488),
                      backgroundColor: const Color(0xFFF0FDFA),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('راشن بل (+)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: OutlinedButton(
                    onPressed: onStockPressed,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      backgroundColor: const Color(0xFFEFF6FF),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('اسٹاک انٹری (+)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}