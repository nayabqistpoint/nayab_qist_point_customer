import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/customer_ledger_controller.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_section/installment_table_components_ui/mobile_selector_dropdown_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/main_page_components_ui/active_order_summary_card_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_section/installment_table_components_ui/installment_table_header_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_section/installment_table_components_ui/installment_table_row_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_section/installment_table_components_ui/installment_pending_freeze_banner_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_section/services/ledger_math_service.dart';

class InstallmentSectionUi extends StatelessWidget {
  final CustomerLedgerController controller;
  const InstallmentSectionUi({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasProducts = controller.customerProducts.isNotEmpty;
    if (!hasProducts) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Center(
          child: Text(
            'اس کسٹمر کے نام پر کوئی فعال اقساط کا پلان موجود نہیں ہے۔',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
            ),
          ),
        ),
      );
    }

    final currentProduct = controller.customerProducts[controller.selectedProductIndex];
    final scheduleList = (currentProduct['schedule'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];
    final overdueSummary = LedgerMathService.calculateOverdueSummary(scheduleList);
    final bool hasPendingReview = currentProduct['hasPendingReview'] == true;
    final int pendingAmount = (currentProduct['pendingAmount'] as int?) ?? 0;

    int? activePayableNo;
    if (!hasPendingReview) {
      for (final item in scheduleList) {
        final int remaining = (item['remainingAmount'] as int?) ?? 0;
        final bool isPaid = item['isApproved'] == true && remaining <= 0;
        if (!isPaid && remaining > 0) {
          activePayableNo = item['no'] as int?;
          break;
        }
      }
    }

    return Column(
      children: [
        MobileSelectorDropdownUi(
          products: controller.customerProducts,
          selectedIndex: controller.selectedProductIndex,
          onChanged: (v) => controller.setProductIndex(v ?? 0),
        ),
        const SizedBox(height: 8),
        ActiveOrderSummaryCardUi(
          itemName: currentProduct['name']?.toString() ?? 'موبائل فون',
          totalContract: (currentProduct['total'] as int?) ?? 0,
          totalPaid: (currentProduct['paid'] as int?) ?? 0,
          totalRemaining: (currentProduct['remaining'] as int?) ?? 0,
          totalMonths: (currentProduct['rawOrder']?['totalMonths'] as num?)?.toInt() ?? scheduleList.length,
          formatAmount: controller.formatAmount,
        ),
        const SizedBox(height: 2),
        if (hasPendingReview)
          InstallmentPendingFreezeBannerUi(
            pendingAmount: pendingAmount,
            formatAmount: controller.formatAmount,
          ),
        Container(
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
                overdueCount: overdueSummary['count'] as int,
                overdueAmount: overdueSummary['amount'] as int,
                formatAmount: controller.formatAmount,
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              Table(
                border: TableBorder.symmetric(
                  inside: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(0.6),
                  1: FlexColumnWidth(1.2),
                  2: FlexColumnWidth(2.4),
                },
                children: [
                  ...scheduleList.map((item) {
                    final int itemNo = (item['no'] as int?) ?? 0;
                    final bool isPaid = item['isApproved'] == true && ((item['remainingAmount'] as int?) ?? 0) <= 0;
                    final bool isUnderReview = item['isUnderReview'] == true;
                    final bool isLocked = !isPaid && !isUnderReview && (hasPendingReview || itemNo != activePayableNo);

                    return InstallmentTableRowUi.build(
                      context: context,
                      item: item,
                      isLocked: isLocked,
                      formatAmount: controller.formatAmount,
                      onPaymentRequested: (it) => controller.handleInstallmentPayment(
                        context,
                        it,
                        itemName: currentProduct['name']?.toString() ?? 'موبائل فون',
                        planTitle: currentProduct['plan']?.toString() ?? 'اقساط پلان',
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}