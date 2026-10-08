import 'package:flutter/material.dart';

class CustomerStatementSheetUi extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final String Function(int) formatAmount;

  const CustomerStatementSheetUi({
    super.key,
    required this.transactions,
    required this.formatAmount,
  });

  static void show(
    BuildContext context, {
    required List<Map<String, dynamic>> transactions,
    required String Function(int) formatAmount,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomerStatementSheetUi(
        transactions: transactions,
        formatAmount: formatAmount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.82,
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          children: [
            // ڈریگ ہینڈل اور ہیڈر
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.receipt_long_rounded, color: Color(0xFF0D9488), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'کھاتہ پاس بک و رسیدیں (ہسٹری)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'کل ٹرانزیکشنز: ${transactions.length}',
                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // لسٹ ویو
            Expanded(
              child: transactions.isEmpty
                  ? const Center(
                      child: Text(
                        'ابھی تک کوئی رسید یا لین دین کا ریکارڈ موجود نہیں ہے۔',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(14),
                      itemCount: transactions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        final String vStatus = (tx['verificationStatus'] ?? 'UNDER_REVIEW').toString().toUpperCase();
                        final bool isApproved = vStatus == 'APPROVED' || vStatus == 'VERIFIED';
                        final bool isRejected = vStatus == 'REJECTED';

                        final int totalPaid = (tx['totalPaid'] as num?)?.toInt() ?? 0;
                        final int discount = (tx['discount'] as num?)?.toInt() ?? 0;
                        final splits = (tx['splits'] as List?)?.cast<Map<String, dynamic>>() ?? [];
                        final logs = (tx['allocationSummary'] as List?)?.cast<String>() ?? [];

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isRejected
                                  ? const Color(0xFFFECACA)
                                  : (isApproved ? const Color(0xFFE2E8F0) : const Color(0xFFFCD34D)),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ٹاپ بار: ٹائٹل اور تصدیق
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      tx['title']?.toString() ?? 'ادائیگی رسید',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  _statusBadge(vStatus),
                                ],
                              ),
                              const SizedBox(height: 6),

                              // رقم اور رسید نمبر
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'رسید نمبر: ${tx['txId'] ?? '-'}',
                                    style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Rs. ${formatAmount(totalPaid)}',
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF059669)),
                                  ),
                                ],
                              ),

                              // اگر رعایت بھی تھی
                              if (discount > 0) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'رعایت / چھوٹ: Rs. ${formatAmount(discount)}',
                                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                                ),
                              ],

                              // واٹر فال تقسیم کا خلاصہ
                              if (logs.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(6),
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

                              // ادائیگی کا ذریعہ (کیش یا بینک)
                              if (splits.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  children: splits.map((s) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF6FF),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: const Color(0xFFBFDBFE)),
                                      ),
                                      child: Text(
                                        '${s['source']}: Rs. ${formatAmount((s['amount'] as num?)?.toInt() ?? 0)}',
                                        style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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