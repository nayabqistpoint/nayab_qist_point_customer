import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';

// کنٹرولر و سیشن
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/main_dashboard/customer_ledger_controller.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/shared/customer_session_context_service.dart';

// مین ڈیش بورڈ کمپوننٹس
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/main_dashboard/components/ledger_app_bar_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/main_dashboard/components/wallet_master_card_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/main_dashboard/components/category_tabs_ui.dart';

// سب-ویوز کمپوننٹس
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_subview/components/installment_section_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/cash_loan_subview/components/cash_loan_section_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/components/service_transactions_section_ui.dart';

import 'package:nayab_qist_point_customer/customer_side/inspector/floating_inspector_ui.dart';

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
    controller = CustomerLedgerController(
      customerPhone: widget.customerPhone ?? '',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (controller.customerPhone.isEmpty) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['customerPhone'] != null) {
        final phone = args['customerPhone'].toString();
        controller.customerPhone = phone;
        CustomerSessionContextService.setActivePhone(phone);
        controller.loadCustomerData();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: LedgerAppBarUi(
              onPurchasePressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.purchaseMarket,
                  arguments: {
                    'customerPhone': controller.customerPhone,
                  },
                );
              },
              onStatementPressed: () => controller.openCustomerStatement(context),
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: const Color(0xFF059669),
              elevation: 4,
              icon: const Icon(Icons.bug_report_rounded, color: Colors.white, size: 22),
              label: const Text(
                'انسپکٹر',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              onPressed: () => FloatingInspectorUi.show(context),
            ),
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  WalletMasterCardUi(
                    net: controller.grandNetTotal,
                    isDebtor: controller.grandNetTotal >= 0,
                    totalInstallmentDue: controller.totalInstallmentDue,
                    cashLoanBalance: controller.cashLoanBalance,
                    pendingServiceCredit: controller.pendingServiceCredit,
                    formatAmount: controller.formatAmount,
                  ),
                  const SizedBox(height: 12),
                  CategoryTabsUi(
                    selectedTabIndex: controller.selectedTabIndex,
                    totalInstallmentDue: controller.totalInstallmentDue,
                    cashLoanBalance: controller.cashLoanBalance,
                    approvedServiceCredit: controller.approvedServiceCredit,
                    formatAmount: controller.formatAmount,
                    onTabSelected: (idx) => controller.setTabIndex(idx),
                  ),
                  const SizedBox(height: 12),
                  if (controller.selectedTabIndex == 0)
                    InstallmentSectionUi(controller: controller),
                  if (controller.selectedTabIndex == 1)
                    CashLoanSectionUi(
                      cashLoanBalance: controller.cashLoanBalance,
                      cashLoanEntries: controller.cashLoanEntries,
                      formatAmount: controller.formatAmount,
                      onRepaymentPressed: () => controller.handleCashLoanRepayment(context),
                    ),
                  if (controller.selectedTabIndex == 2)
                    ServiceTransactionsSectionUi(
                      serviceTransactions: controller.serviceTransactions,
                      formatAmount: controller.formatAmount,
                      onNewServicePressed: () => controller.handleNewServiceTransaction(context),
                      onToggleExpand: controller.toggleTransactionExpand,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}