// lib/customer_side/cutomer_ledger/customer_ledger_components_ui/cash_loan_section_ui.dart

import 'package:flutter/material.dart';

class CashLoanSectionUi extends StatelessWidget {
  final int cashLoanBalance;
  final List<Map<String, dynamic>> cashLoanEntries;
  final String Function(int) formatAmount;
  final VoidCallback onRepaymentPressed;

  const CashLoanSectionUi({
    super.key,
    required this.cashLoanBalance,
    required this.cashLoanEntries,
    required this.formatAmount,
    required this.onRepaymentPressed,
  });

  /// ہر ٹرانزیکشن کے وقت کا تاریخی رننگ بیلنس معلوم کرنا
  List<Map<String, dynamic>> _computeRunningBalances() {
    int current = cashLoanBalance;
    final List<Map<String, dynamic>> computed = [];

    // اوپر سے نیچے (تازہ ترین سے پرانی تاریخ کی طرف) رننگ بیلنس بیک ٹریک کرنا
    for (int i = 0; i < cashLoanEntries.length; i++) {
      final entry = Map<String, dynamic>.from(cashLoanEntries[i]);
      final int amt = (entry['amount'] as int?) ?? 0;
      final String type = (entry['type'] ?? 'DEBIT').toString().toUpperCase();

      entry['runningBalanceAtThisPoint'] = current;
      computed.add(entry);

      // پچھلی حالت کا حساب
      if (type == 'DEBIT') {
        current -= amt;
      } else {
        current += amt;
      }
    }
    return computed;
  }

  @override
  Widget build(BuildContext context) {
    final bool isCustomerAdvance = cashLoanBalance < 0;
    final bool hasDues = cashLoanBalance > 0;
    final entriesWithBalance = _computeRunningBalances();

    return Column(
      children: [
        // 1. اوپر کا سمری ہیڈر کارڈ
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFCBD5E1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCustomerAdvance ? 'آپ کی پیشگی جمع شدہ رقم (ایڈوانس):' : 'کل نقد دستی ادھار واجب الادا:',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${isCustomerAdvance ? '-' : ''}Rs. ${formatAmount(cashLoanBalance.abs())}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: isCustomerAdvance ? const Color(0xFF059669) : const Color(0xFFDC2626),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (hasDues)
                Flexible(
                  fit: FlexFit.loose,
                  child: ElevatedButton.icon(
                    onPressed: onRepaymentPressed,
                    icon: const Icon(Icons.payment_rounded, size: 14),
                    label: const Text(
                      'قرض واپس کریں',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 2. تاریخی رننگ لیجر لسٹ
        if (entriesWithBalance.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Center(
              child: Text(
                'کوئی نقد لین دین موجود نہیں ہے۔',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
              ),
            ),
          )
        else
          ...entriesWithBalance.map((e) {
            final String type = (e['type'] ?? 'DEBIT').toString().toUpperCase();
            final bool isRepayment = type == 'CREDIT';
            final int amt = (e['amount'] as int?) ?? 0;
            final int runBal = (e['runningBalanceAtThisPoint'] as int?) ?? 0;
            final bool isBalDebit = runBal > 0;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // تفصیلات اور تاریخ
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isRepayment ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                isRepayment ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                size: 12,
                                color: isRepayment ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                e['title']?.toString() ?? (isRepayment ? 'دستی قرض واپسی ادا کی' : 'نقد دستی کیش لیا'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          e['date']?.toString() ?? 'آج',
                          style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // ٹرانزیکشن رقم اور اس کے بعد کا رننگ بیلنس
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${isRepayment ? '-' : '+'}Rs. ${formatAmount(amt)}',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                          color: isRepayment ? const Color(0xFF059669) : const Color(0xFFDC2626),
                        ),
                      ),
                      const SizedBox(height: 3),
                      // رننگ بیلنس بیج
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isBalDebit ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isBalDebit ? const Color(0xFFFECACA) : const Color(0xFFBBF7D0),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          'بقیہ: Rs. ${formatAmount(runBal.abs())}',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: isBalDebit ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}