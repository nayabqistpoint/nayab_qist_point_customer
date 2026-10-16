import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'installment_args.dart';
import 'installment_controller.dart';
import 'components/mobile_selector_dropdown_ui.dart';
import 'components/active_order_summary_card_ui.dart';
import 'components/installment_pending_freeze_banner_ui.dart';
import 'components/installment_table_header_ui.dart';
import 'components/installment_table_row_ui.dart';

class InstallmentAccountPage extends StatefulWidget {
  final InstallmentArgs args;

  const InstallmentAccountPage({
    super.key,
    required this.args,
  });

  @override
  State<InstallmentAccountPage> createState() => _InstallmentAccountPageState();
}

class _InstallmentAccountPageState extends State<InstallmentAccountPage> {
  late final InstallmentController controller;

  @override
  void initState() {
    super.initState();
    controller = InstallmentController(args: widget.args);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    final bool hasProducts = controller.customerProducts.isNotEmpty;
    if (!hasProducts) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(12),
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

    final currentProduct = controller.currentProduct;
    final scheduleList = controller.currentSchedule;
    final overdueSummary = controller.currentOverdueSummary;
    final bool hasPendingReview = currentProduct['hasPendingReview'] == true;
    final int pendingAmount = (currentProduct['pendingAmount'] as int?) ?? 0;
    final int? activePayableNo = controller.activePayableInstallmentNo;

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
                  border: const TableBorder.symmetric(
                    inside: BorderSide(color: Color(0xFFE2E8F0), width: 1),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listenable = controller.boxListenable;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF0F172A),
          title: const Text(
            'اقساط کھاتہ تفصیلات',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: listenable == null
            ? AnimatedBuilder(
                animation: controller,
                builder: (context, _) => _buildBody(),
              )
            : ValueListenableBuilder<Box>(
                valueListenable: listenable,
                builder: (context, _, __) {
                  controller.loadInstallmentData();
                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) => _buildBody(),
                  );
                },
              ),
      ),
    );
  }
}