import 'package:flutter/material.dart';
import 'installment_table_header_ui.dart';
import 'installment_table_row_ui.dart';

class InstallmentScheduleTableUi extends StatelessWidget {
  final Map<String, dynamic> currentProduct;
  final List<Map<String, dynamic>> scheduleList;
  final Map<String, dynamic> overdueSummary;
  final int? activePayableNo;
  final bool hasPendingReview;
  final String Function(int) formatAmount;
  final ValueChanged<Map<String, dynamic>> onPaymentRequested;

  const InstallmentScheduleTableUi({
    super.key,
    required this.currentProduct,
    required this.scheduleList,
    required this.overdueSummary,
    required this.activePayableNo,
    required this.hasPendingReview,
    required this.formatAmount,
    required this.onPaymentRequested,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          InstallmentTableHeaderUi(
            planName: currentProduct['plan']?.toString() ?? '',
            orderStatus: currentProduct['orderStatus']?.toString() ?? 'PENDING',
            overdueCount: overdueSummary['count'] as int? ?? 0,
            overdueAmount: overdueSummary['amount'] as int? ?? 0,
            formatAmount: formatAmount,
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Table(
            border: const TableBorder.symmetric(
              inside: BorderSide(color: Color(0xFFE2E8F0), width: 1),
            ),
            columnWidths: const {
              0: FlexColumnWidth(0.6),
              1: FlexColumnWidth(1.2),
              2: FlexColumnWidth(2.4),
            },
            children: scheduleList.map((item) {
              final int itemNo = (item['no'] as int?) ?? 0;
              final bool isPaid = item['isApproved'] == true && ((item['remainingAmount'] as int?) ?? 0) <= 0;
              final bool isUnderReview = item['isUnderReview'] == true;
              final bool isLocked = !isPaid && !isUnderReview && (hasPendingReview || itemNo != activePayableNo);

              return InstallmentTableRowUi.build(
                context: context,
                item: item,
                isLocked: isLocked,
                formatAmount: formatAmount,
                onPaymentRequested: onPaymentRequested,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}