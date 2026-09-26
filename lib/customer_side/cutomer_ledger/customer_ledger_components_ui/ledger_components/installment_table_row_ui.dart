import 'package:flutter/material.dart';
import 'installment_action_badge_ui.dart';

class InstallmentTableRowUi {
  static TableRow build({
    required BuildContext context,
    required Map<String, dynamic> item,
    required String Function(int) formatAmount,
    required ValueChanged<Map<String, dynamic>> onPaymentRequested,
  }) {
    final String status = item['status'] ?? 'UPCOMING';
    final String verificationStatus = item['verificationStatus'] ?? 'UNDER_REVIEW';

    final bool isPaid = status == 'PAID';
    final bool isDue = status == 'DUE';
    final bool isPartial = status == 'PARTIAL';

    final int totalAmt = (item['amount'] as int?) ?? 0;
    final int paidAmt = (item['paidAmount'] as int?) ?? 0;
    final int remainingAmt = (item['remainingAmount'] as int?) ?? (totalAmt - paidAmt);
    final int percent = (item['percent'] as int?) ?? 0;
    final double progressRatio = (percent / 100.0).clamp(0.0, 1.0);

    final bool isUnderReview = paidAmt > 0 && verificationStatus == 'UNDER_REVIEW';

    Color progressColor;
    if (isPaid && !isUnderReview) {
      progressColor = const Color(0xFF059669);
    } else if (isUnderReview) {
      progressColor = const Color(0xFFD97706);
    } else if (isDue) {
      progressColor = const Color(0xFFDC2626);
    } else {
      progressColor = const Color(0xFF0D9488);
    }

    return TableRow(
      decoration: BoxDecoration(color: isDue ? const Color(0xFFFEF2F2) : Colors.transparent),
      children: [
        // 1. قسط نمبر
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Text(
            '${item['no']}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
        ),

        // 2. تاریخ
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Text(
            item['date']?.toString() ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDue ? const Color(0xFFDC2626) : const Color(0xFF334155),
            ),
          ),
        ),

        // 3. پروگریس بار، رقم اور ماڈیولر ایکشن بٹن
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'قسط: Rs. ${formatAmount(totalAmt)}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$percent%',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: progressColor),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progressRatio,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isDue
                                  ? Icons.error_outline_rounded
                                  : isPartial
                                      ? Icons.timelapse_rounded
                                      : Icons.receipt_rounded,
                              size: 11,
                              color: isDue || isPartial ? const Color(0xFFDC2626) : const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              isPartial ? 'بقیہ:' : 'واجب:',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: isDue || isPartial ? const Color(0xFFDC2626) : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Rs. ${formatAmount(isPartial ? remainingAmt : (isPaid ? 0 : totalAmt))}',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w900,
                              color: isDue || isPartial ? const Color(0xFFDC2626) : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        if (isUnderReview)
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Text(
                              '● زیرِ تصدیق',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFFD97706)),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  InstallmentActionBadgeUi(
                    isPaid: isPaid,
                    isUnderReview: isUnderReview,
                    isDue: isDue,
                    isPartial: isPartial,
                    onTap: () => onPaymentRequested(item),
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