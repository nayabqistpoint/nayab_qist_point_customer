import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'customer_ledger_controller.dart';
import 'components/ledger_app_bar_ui.dart';
import 'components/shop_notice_ticker_ui.dart';
import 'components/wallet_master_card_ui.dart';
import 'components/installment_gateway_card_ui.dart';
import 'components/cash_account_gateway_card_ui.dart';
import 'components/frozen_bottom_action_bar_ui.dart';

class CustomerLedgerView extends StatefulWidget {
  final String? customerPhone;

  const CustomerLedgerView({
    super.key,
    this.customerPhone,
  });

  @override
  State<CustomerLedgerView> createState() => _CustomerLedgerViewState();
}

class _CustomerLedgerViewState extends State<CustomerLedgerView> {
  late final CustomerLedgerController controller;

  @override
  void initState() {
    super.initState();
    controller = CustomerLedgerController(customerPhone: widget.customerPhone ?? '');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (controller.customerPhone.isEmpty) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['customerPhone'] != null) {
        controller.customerPhone = args['customerPhone'].toString();
        controller.refreshDashboardData();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShopNoticeTickerUi(),
          const SizedBox(height: 14),
          WalletMasterCardUi(
            netAmount: controller.grandNetTotal,
            isDebtor: controller.isDebtor,
            formatAmount: controller.formatAmount,
          ),
          const SizedBox(height: 18),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              'کھاتہ تفصیلات و انتظام',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          InstallmentGatewayCardUi(
            itemName: controller.activeMobileTitle,
            planTitle: controller.activePlanSubtitle,
            remainingAmount: controller.totalInstallmentDue,
            overdueCount: controller.overdueInstallmentCount,
            overdueAmount: controller.overdueInstallmentAmount,
            formatAmount: controller.formatAmount,
            onTap: () => controller.openInstallmentPage(context),
          ),
          const SizedBox(height: 14),
          CashAccountGatewayCardUi(
            balance: controller.cashLoanBalance,
            hasAdvance: controller.hasAdvance,
            formatAmount: controller.formatAmount,
            onTap: () => controller.openCashLoanPage(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: const LedgerAppBarUi(),
        body: Hive.isBoxOpen(HiveBoxManager.customerBoxName) &&
                Hive.isBoxOpen(HiveBoxManager.installmentsBoxName)
            ? ValueListenableBuilder(
                valueListenable: Hive.box(HiveBoxManager.customerBoxName).listenable(),
                builder: (context, _, __) {
                  return ValueListenableBuilder(
                    valueListenable: Hive.box(HiveBoxManager.installmentsBoxName).listenable(),
                    builder: (context, _, __) {
                      controller.refreshDashboardData();
                      return ListenableBuilder(
                        listenable: controller,
                        builder: (context, _) => _buildBody(),
                      );
                    },
                  );
                },
              )
            : ListenableBuilder(
                listenable: controller,
                builder: (context, _) => _buildBody(),
              ),
        bottomNavigationBar: FrozenBottomActionBarUi(
          onStatementPressed: () => controller.openStatementSheet(context),
          onPurchasePressed: () => controller.openPurchaseMarket(context),
        ),
      ),
    );
  }
}