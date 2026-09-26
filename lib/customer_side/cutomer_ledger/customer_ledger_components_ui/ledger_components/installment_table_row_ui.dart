import 'package:flutter/material.dart';

class InstallmentTableRowUi {
  static TableRow build({
    required BuildContext context,
    required Map<String, dynamic> item,
    required String Function(int) formatAmount,
    required ValueChanged<Map<String, dynamic>> onPaymentRequested,
  }) {
    final String status = item['status'] ?? 'UPCOMING';
    final bool isPaid = status == 'PAID';
    final bool isDue = status == 'DUE';
    final bool isPartial = status == 'PARTIAL';

    final int totalAmt = (item['amount'] as int?) ?? 0;
    final int paidAmt = (item['paidAmount'] as int?) ?? 0;
    final int remainingAmt = (item['remainingAmount'] as int?) ?? (totalAmt - paidAmt);
    final int percent = (item['percent'] as int?) ?? 0;
    final double progressRatio = (percent / 100.0).clamp(0.0, 1.0);

    return TableRow(
      decoration: BoxDecoration(
        color: isDue ? const Color(0xFFFEF2F2) : Colors.transparent, // واجب الادا کے لیے ہلکا سرخ بیک گراؤنڈ
      ),
      children: [
        // 1. قسط نمبر
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Text(
            '${item['no']}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ),

        // 2. تاریخ
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Text(
            item['date']?.toString() ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: isDue ? const Color(0xFFDC2626) : const Color(0xFF334155),
            ),
          ),
        ),

        // 3. تفصیلات، پروگریس بار اور ادائیگی بٹن
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // قسط اور فیصد
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'قسط: Rs. ${formatAmount(totalAmt)}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$percent%',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: isPaid
                          ? const Color(0xFF059669)
                          : isDue
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF0D9488),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // پروگریس بار
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progressRatio,
                  minHeight: 6.5,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isPaid
                        ? const Color(0xFF059669)
                        : isDue
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF0D9488),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // نیچے کا ٹیکسٹ اور بٹن
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isPaid
                          ? 'مکمل ادا شدہ'
                          : paidAmt > 0
                              ? 'باقی: Rs. ${formatAmount(remainingAmt)}'
                              : 'واجب: Rs. ${formatAmount(totalAmt)}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isPaid
                            ? const Color(0xFF059669)
                            : isDue
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF64748B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // بٹن یا مکمل ادا کا بیج
                  if (isPaid)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF86EFAC)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF16A34A)),
                          SizedBox(width: 4),
                          Text(
                            'مکمل ادا',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onPaymentRequested(item),
                        borderRadius: BorderRadius.circular(8),
                        child: Ink(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
                          decoration: BoxDecoration(
                            color: isDue
                                ? const Color(0xFFDC2626)
                                : isPartial
                                    ? const Color(0xFF0D9488)
                                    : const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.payment_rounded, size: 12, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                isDue ? 'واجب ادا کریں' : 'ادائیگی کریں',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}