import 'package:flutter/material.dart';

class TransactionCardTileUi extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final String Function(int) formatAmount;

  const TransactionCardTileUi({
    super.key,
    required this.transaction,
    required this.formatAmount,
  });

  @override
  Widget build(BuildContext context) {
    final String vStatus = (transaction['verificationStatus'] ?? 'UNDER_REVIEW').toString().toUpperCase();
    final bool isApproved = vStatus == 'APPROVED' || vStatus == 'VERIFIED';
    final bool isRejected = vStatus == 'REJECTED';

    final int totalPaid = (transaction['totalPaid'] as num?)?.toInt() ??
        (transaction['amount'] as num?)?.toInt() ??
        0;
    final int discount = (transaction['discount'] as num?)?.toInt() ?? 0;
    final splits = (transaction['splits'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final logs = (transaction['allocationSummary'] as List?)?.cast<String>() ?? [];
    final dateStr = (transaction['date'] ?? transaction['paymentDate'] ?? '-').toString();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isRejected
              ? const Color(0xFFFECACA)
              : (isApproved ? const Color(0xFFE2E8F0) : const Color(0xFFFCD34D)),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  transaction['title']?.toString() ?? 'ادائیگی رسید',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _statusBadge(vStatus),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'رسید نمبر: ${transaction['txId'] ?? transaction['docId'] ?? '-'}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
              ),
              Text(
                'Rs. ${formatAmount(totalPaid)}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF059669)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(
                dateStr,
                style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
              ),
            ],
          ),
          if (discount > 0) ...[
            const SizedBox(height: 6),
            Text(
              'رعایت / چھوٹ: Rs. ${formatAmount(discount)}',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
            ),
          ],
          if (logs.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: logs.map((log) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      '• $log',
                      style: const TextStyle(fontSize: 10, color: Color(0xFF334155), fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          if (splits.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: splits.map((s) {
                final amt = (s['amount'] as num?)?.toInt() ?? 0;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Text(
                    '${s['source']}: Rs. ${formatAmount(amt)}',
                    style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color border;
    Color text;
    String label;

    if (status == 'APPROVED' || status == 'VERIFIED') {
      bg = const Color(0xFFDCFCE7);
      border = const Color(0xFF86EFAC);
      text = const Color(0xFF16A34A);
      label = 'منظور شدہ ✓';
    } else if (status == 'REJECTED') {
      bg = const Color(0xFFFEE2E2);
      border = const Color(0xFFFECACA);
      text = const Color(0xFFDC2626);
      label = 'مسترد ✕';
    } else {
      bg = const Color(0xFFFEF3C7);
      border = const Color(0xFFFCD34D);
      text = const Color(0xFFB45309);
      label = 'زیرِ جائزہ ⏳';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: text),
      ),
    );
  }
}