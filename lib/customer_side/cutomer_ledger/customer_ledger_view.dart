import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';
import 'customer_ledger_controller.dart';
import 'customer_ledger_components_ui/ledger_app_bar_ui.dart';
import 'customer_ledger_components_ui/wallet_master_card_ui.dart';
import 'customer_ledger_components_ui/category_tabs_ui.dart';
import 'customer_ledger_components_ui/mobile_selector_dropdown_ui.dart';
import 'customer_ledger_components_ui/installment_table_header_ui.dart';
import 'customer_ledger_components_ui/installment_table_row_ui.dart';
import 'customer_ledger_components_ui/cash_loan_section_ui.dart';
import 'customer_ledger_components_ui/service_transactions_section_ui.dart';

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
  final CustomerLedgerController controller = CustomerLedgerController();

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
        final currentProduct = controller.customerProducts[controller.selectedProductIndex];
        final scheduleList = (currentProduct['schedule'] as List?) ?? [];

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
                    'customerPhone': widget.customerPhone,
                  },
                );
              },
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
                    approvedServiceCredit: controller.approvedServiceCredit,
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
                  if (controller.selectedTabIndex == 0) ...[
                    MobileSelectorDropdownUi(
                      products: controller.customerProducts,
                      selectedIndex: controller.selectedProductIndex,
                      onChanged: (v) => controller.setProductIndex(v ?? 0),
                    ),
                    const SizedBox(height: 10),
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
                            monthlyInstallment: controller.formatAmount(
                              (currentProduct['monthlyInstallment'] as int?) ?? 0,
                            ),
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
                                return InstallmentTableRowUi.build(
                                  context: context,
                                  item: item,
                                  formatAmount: controller.formatAmount,
                                  onPaymentRequested: (it) => controller.handleInstallmentPayment(context, it),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (controller.selectedTabIndex == 1) ...[
                    CashLoanSectionUi(
                      cashLoanBalance: controller.cashLoanBalance,
                      cashLoanEntries: controller.cashLoanEntries,
                      formatAmount: controller.formatAmount,
                      onRepaymentPressed: () => controller.handleCashLoanRepayment(context),
                    ),
                  ],
                  if (controller.selectedTabIndex == 2) ...[
                    ServiceTransactionsSectionUi(
                      serviceTransactions: controller.serviceTransactions,
                      formatAmount: controller.formatAmount,
                      onNewServicePressed: () => controller.handleNewServiceTransaction(context),
                      onToggleExpand: (tx) => controller.toggleTransactionExpand(tx),
                    ),
                  ],
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}