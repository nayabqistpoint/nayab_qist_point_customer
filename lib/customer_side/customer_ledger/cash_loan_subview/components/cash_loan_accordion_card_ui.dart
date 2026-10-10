import 'package:flutter/material.dart';
import 'grocery_table_accordion_ui.dart';
import 'stock_table_accordion_ui.dart';
import 'cash_repayment_accordion_ui.dart';

class CashLoanAccordionCardUi extends StatelessWidget {
  final Map<String, dynamic> entry;
  final bool isExpanded;
  final VoidCallback onToggle;
  final String Function(int) formatAmount;

  const CashLoanAccordionCardUi({
    super.key,
    required this.entry,
    required this.isExpanded,
    required this.onToggle,
    required this.formatAmount,
  });

  @override
  Widget build(BuildContext context) {
    final String txType = (entry['txType'] ?? 'CASH').toString().toUpperCase();
    final int amt = (entry['amount'] as num?)?.toInt() ?? 0;
    final int runBal = (entry['runningBalanceAtThisPoint'] as int?) ?? 0;
    final bool isBalDebit = runBal > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isExpanded ? _getBorderColor(txType) : const Color(0xFFE2E8F0),
          width: isExpanded ? 1.4 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Row(
                children: [
                  _buildBadge(txType),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry['title'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 3),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 4,
                          children: [
                            Text(
                              entry['date'] ?? 'آج',
                              style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                            ),
                            if (entry['hasPhoto'] == true)
                              const Icon(Icons.image_outlined, size: 12, color: Color(0xFF0F766E)),
                            if (entry['hasAudio'] == true)
                              const Icon(Icons.mic_none_rounded, size: 12, color: Color(0xFF0F766E)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '-Rs. ${formatAmount(amt)}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF059669)),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: isBalDebit ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isBalDebit ? const Color(0xFFFECACA) : const Color(0xFFBBF7D0),
                                width: 0.6,
                              ),
                            ),
                            child: Text(
                              'بقیہ: ${formatAmount(runBal.abs())}',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: isBalDebit ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                              ),
                            ),
                          ),
                          Icon(
                            isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                            color: const Color(0xFF64748B),
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            if (txType == 'GROCERY') GroceryTableAccordionUi(entry: entry, formatAmount: formatAmount),
            if (txType == 'STOCK') StockTableAccordionUi(entry: entry, formatAmount: formatAmount),
            if (txType == 'CASH') CashRepaymentAccordionUi(entry: entry, formatAmount: formatAmount),
          ],
        ],
      ),
    );
  }

  Widget _buildBadge(String txType) {
    IconData icon;
    Color bg;
    Color color;

    switch (txType) {
      case 'GROCERY':
        icon = Icons.shopping_basket_rounded;
        bg = const Color(0xFFCCFBF1);
        color = const Color(0xFF0F766E);
        break;
      case 'STOCK':
        icon = Icons.phone_android_rounded;
        bg = const Color(0xFFDBEAFE);
        color = const Color(0xFF1D4ED8);
        break;
      default:
        icon = Icons.payments_rounded;
        bg = const Color(0xFFDCFCE7);
        color = const Color(0xFF16A34A);
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 15, color: color),
    );
  }

  Color _getBorderColor(String txType) {
    switch (txType) {
      case 'GROCERY':
        return const Color(0xFF0D9488);
      case 'STOCK':
        return const Color(0xFF2563EB);
      default:
        return const Color(0xFF16A34A);
    }
  }
}