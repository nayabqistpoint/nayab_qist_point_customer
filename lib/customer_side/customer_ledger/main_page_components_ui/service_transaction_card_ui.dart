import 'package:flutter/material.dart';

class ServiceTransactionCardUi extends StatelessWidget {
  final Map<String, dynamic> tx;
  final String Function(int) formatAmount;
  final VoidCallback onToggleExpand;

  const ServiceTransactionCardUi({
    super.key,
    required this.tx,
    required this.formatAmount,
    required this.onToggleExpand,
  });

  Widget _buildSyncBadge() {
    final bool isApproved = (tx['status'] ?? '').toString().toUpperCase() == 'APPROVED';
    final bool isSynced = tx['isSynced'] ?? true;

    if (isApproved) {
      return _tag(Icons.check_circle_rounded, 'منظور شدہ', const Color(0xFF16A34A), const Color(0xFFDCFCE7), const Color(0xFF86EFAC));
    }
    return isSynced
        ? _tag(Icons.done_all_rounded, 'ایڈمن موصول', const Color(0xFF2563EB), const Color(0xFFEFF6FF), const Color(0xFFBFDBFE))
        : _tag(Icons.check_rounded, 'ہائیو باکس', const Color(0xFF64748B), const Color(0xFFF1F5F9), const Color(0xFFCBD5E1));
  }

  Widget _tag(IconData icon, String text, Color c, Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6), border: Border.all(color: border)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: c),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: c)),
        ],
      ),
    );
  }

  TableRow _buildRow(List<Widget> cells, {Color? bg}) {
    return TableRow(
      decoration: BoxDecoration(color: bg),
      children: cells.map((w) => Padding(padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5), child: w)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isExpanded = tx['isExpanded'] ?? false;
    final int grandTotal = (tx['totalAmount'] as int?) ?? 0;
    final List itemsList = (tx['items'] as List?) ?? [];
    final int totalQty = itemsList.fold(0, (sum, itm) => sum + ((itm['qty'] as num? ?? 1).toInt()));

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggleExpand,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          tx['title']?.toString() ?? 'خدمت / اسٹاک تبادلہ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Rs. ${formatAmount(grandTotal)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF0D9488))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'تاریخ: ${tx['date'] ?? 'آج'} | کھاتہ: ${tx['targetAccount'] ?? 'عمومی'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      _buildSyncBadge(),
                      const SizedBox(width: 4),
                      Icon(isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, size: 20, color: const Color(0xFF64748B)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (itemsList.isNotEmpty) ...[
                    Table(
                      border: TableBorder.all(color: const Color(0xFFE2E8F0), width: 0.8),
                      columnWidths: const {0: FlexColumnWidth(2.5), 1: FlexColumnWidth(0.9), 2: FlexColumnWidth(1.4), 3: FlexColumnWidth(1.6)},
                      children: [
                        _buildRow([
                          const Text('تفصیل / خدمت', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          const Text('تعداد', textAlign: TextAlign.center, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          const Text('ریٹ', textAlign: TextAlign.center, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          const Text('کل رقم', textAlign: TextAlign.center, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                        ], bg: const Color(0xFFF8FAFC)),
                        ...itemsList.map((itm) {
                          final int qty = (itm['qty'] as num? ?? 1).toInt();
                          final int rate = (itm['rate'] as num? ?? 0).toInt();
                          return _buildRow([
                            Text(itm['name']?.toString() ?? itm['title']?.toString() ?? '-', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                            Text('$qty', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
                            Text(formatAmount(rate), textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
                            Text(formatAmount(qty * rate), textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          ]);
                        }),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        border: Border(left: BorderSide(color: Color(0xFFE2E8F0)), right: BorderSide(color: Color(0xFFE2E8F0)), bottom: BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('مدات: ${itemsList.length} | کل مقدار: $totalQty', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                          Text('ٹوٹل: Rs. ${formatAmount(grandTotal)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF0D9488))),
                        ],
                      ),
                    ),
                  ],
                  if (tx['note'] != null && tx['note'].toString().trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFFDE68A))),
                      child: Text('کیفیت: ${tx['note']}', style: const TextStyle(fontSize: 10.5, color: Color(0xFF92400E))),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}