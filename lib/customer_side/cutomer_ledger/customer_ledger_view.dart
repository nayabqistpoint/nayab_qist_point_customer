import 'package:flutter/material.dart';
import '../../app_routes.dart';
import 'customer_ledger_controller.dart';
import 'customer_ledger_components_ui/ledger_app_bar_ui.dart';
import 'customer_ledger_components_ui/wallet_master_card_ui.dart';
import 'customer_ledger_components_ui/category_tabs_ui.dart';
import 'customer_ledger_components_ui/ledger_components/mobile_selector_dropdown_ui.dart';
import 'customer_ledger_components_ui/ledger_components/installment_table_header_ui.dart';
import 'customer_ledger_components_ui/ledger_components/installment_table_row_ui.dart';
import 'customer_ledger_components_ui/cash_loan_section_ui.dart';
import 'customer_ledger_components_ui/service_transactions_section_ui.dart';
import '../inspector/floating_inspector_ui.dart';

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
    // اگر فون نمبر روٹ آرگیومنٹس میں بھیجا گیا ہو تو اسے کیچ کرنا
    if (controller.customerPhone.isEmpty) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['customerPhone'] != null) {
        controller.customerPhone = args['customerPhone'].toString();
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
        final bool hasProducts = controller.customerProducts.isNotEmpty;
        final currentProduct = hasProducts
            ? controller.customerProducts[controller.selectedProductIndex]
            : null;
        final scheduleList = (currentProduct?['schedule'] as List?) ?? [];

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
                    if (!hasProducts)
                      Container(
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
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                          ),
                        ),
                      )
                    else ...[
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
                              planName: currentProduct?['plan']?.toString() ?? '',
                              monthlyInstallment: controller.formatAmount(
                                (currentProduct?['monthlyInstallment'] as int?) ?? 0,
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
                                    onPaymentRequested: (it) =>
                                        controller.handleInstallmentPayment(context, it),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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