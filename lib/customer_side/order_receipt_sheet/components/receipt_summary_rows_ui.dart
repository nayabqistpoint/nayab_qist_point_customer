import 'package:flutter/material.dart';

class ReceiptSummaryRowsUi extends StatelessWidget {
  final String deviceName;
  final String guaranteeTitle;
  final int months;
  final int advance;
  final int monthly;
  final int totalInstallmentSum;

  const ReceiptSummaryRowsUi({
    super.key,
    required this.deviceName,
    required this.guaranteeTitle,
    required this.months,
    required this.advance,
    required this.monthly,
    required this.totalInstallmentSum,
  });

  Widget _slipRow(String label, String value, {bool isHighlight = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569))),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold || isHighlight ? FontWeight.bold : FontWeight.w600,
              color: isHighlight ? const Color(0xFF0D9488) : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _slipRow('مطلوبہ موبائل ماڈل:', deviceName),
        _slipRow('ضمانت کی قسم:', guaranteeTitle),
        _slipRow('اقساط کی کل مدت:', '$months ماہ'),
        _slipRow('طے شدہ ایڈوانس رقم:', advance > 0 ? 'Rs. $advance' : '⭐ بغیر ایڈوانس (Zero Advance)'),
        _slipRow('مقررہ ماہانہ قسط:', 'Rs. $monthly / ماہ', isHighlight: true),
        const Divider(color: Color(0xFFE2E8F0)),
        _slipRow('کل اقساط معاہدہ رقم:', 'Rs. $totalInstallmentSum', isBold: true),
      ],
    );
  }
}