import 'package:flutter/material.dart';

class InstallmentTableRowUi {
  static TableRow build({
    required BuildContext context,
    required Map<String, dynamic> item,
    required String Function(int) formatAmount,
    required ValueChanged<Map<String, dynamic>> onPaymentRequested,
  }) {
    final bool isPaid = item['status'] == 'PAID';
    final bool isDue = item['status'] == 'DUE';
    final int totalAmt = item['amount'] as int;
    final int paidAmt = (item['paidAmount'] as int?) ?? (isPaid ? totalAmt : 0);
    final double progressRatio = (totalAmt > 0) ? (paidAmt / totalAmt).clamp(0.0, 1.0) : 0.0;
    final int percent = (progressRatio * 100).toInt();

    return TableRow(
      decoration: BoxDecoration(color: isDue ? const Color(0xFFF0FDFA) : Colors.transparent),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            '${item['no']}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            item['date']?.toString() ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isPaid
                          ? const Color(0xFF059669)
                          : percent > 0
                              ? const Color(0xFF0D9488)
                              : const Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progressRatio,
                  minHeight: 6.5,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isPaid
                        ? const Color(0xFF059669)
                        : percent > 0
                            ? const Color(0xFF0D9488)
                            : const Color(0xFFDC2626),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isPaid
                          ? 'مکمل ادا شدہ'
                          : paidAmt > 0
                              ? 'ادا: Rs. ${formatAmount(paidAmt)}'
                              : 'باقی: Rs. ${formatAmount(totalAmt)}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 10,
                        color: isPaid ? const Color(0xFF059669) : const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: isPaid ? null : () => onPaymentRequested(item),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPaid
                            ? const Color(0xFFDCFCE7)
                            : isDue
                                ? const Color(0xFF0D9488)
                                : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          isPaid ? '✔ ادا' : isDue ? 'ادائیگی' : 'ادا کریں',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isPaid
                                ? const Color(0xFF059669)
                                : isDue
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                          ),
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