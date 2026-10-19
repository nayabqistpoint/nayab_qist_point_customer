import 'package:flutter/material.dart';
import '../installment_controller.dart';
import 'mobile_selector_dropdown_ui.dart';
import 'active_order_summary_card_ui.dart';
import 'installment_pending_freeze_banner_ui.dart';
import 'installment_schedule_table_ui.dart';
import 'installment_empty_state_ui.dart';

class InstallmentViewBodyUi extends StatelessWidget {
  final InstallmentController controller;
  final ValueChanged<Map<String, dynamic>> onPaymentRequested;

  const InstallmentViewBodyUi({
    super.key,
    required this.controller,
    required this.onPaymentRequested,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.customerProducts.isEmpty) {
      return const InstallmentEmptyStateUi();
    }

    final prod = controller.currentProduct;
    final schedule = controller.currentSchedule;
    final bool hasPendingReview = prod['hasPendingReview'] == true;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          MobileSelectorDropdownUi(
            products: controller.customerProducts,
            selectedIndex: controller.selectedProductIndex,
            onChanged: (v) => controller.setProductIndex(v ?? 0),
          ),
          const SizedBox(height: 8),
          ActiveOrderSummaryCardUi(
            itemName: prod['name']?.toString() ?? 'موبائل فون',
            totalContract: (prod['total'] as int?) ?? 0,
            totalPaid: (prod['paid'] as int?) ?? 0,
            totalRemaining: (prod['remaining'] as int?) ?? 0,
            totalMonths: (prod['rawOrder']?['totalMonths'] as num?)?.toInt() ?? schedule.length,
            formatAmount: controller.formatAmount,
          ),
          const SizedBox(height: 2),
          if (hasPendingReview)
            InstallmentPendingFreezeBannerUi(
              pendingAmount: (prod['pendingAmount'] as int?) ?? 0,
              formatAmount: controller.formatAmount,
            ),
          InstallmentScheduleTableUi(
            currentProduct: prod,
            scheduleList: schedule,
            overdueSummary: controller.currentOverdueSummary,
            activePayableNo: controller.activePayableInstallmentNo,
            hasPendingReview: hasPendingReview,
            formatAmount: controller.formatAmount,
            onPaymentRequested: onPaymentRequested,
          ),
        ],
      ),
    );
  }
}