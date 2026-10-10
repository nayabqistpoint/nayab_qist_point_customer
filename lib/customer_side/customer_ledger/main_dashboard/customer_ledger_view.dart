import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';

import 'customer_ledger_controller.dart';
import '../shared/customer_session_context_service.dart';
import 'components/ledger_app_bar_ui.dart';
import 'components/wallet_master_card_ui.dart';
import 'components/category_tabs_ui.dart';
import '../installment_subview/components/installment_section_ui.dart';
import '../cash_loan_subview/cash_loan_section_controller.dart';
import '../cash_loan_subview/cash_loan_section_page.dart';
import '../../inspector/floating_inspector_ui.dart';

class WebAndMobileScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class CustomerLedgerView extends StatefulWidget {
  final String? customerPhone;
  const CustomerLedgerView({super.key, this.customerPhone});

  @override
  State<CustomerLedgerView> createState() => _CustomerLedgerViewState();
}

class _CustomerLedgerViewState extends State<CustomerLedgerView> {
  late final CustomerLedgerController controller;
  late final PageController _pageController;
  late final CashLoanSectionController _cashLoanController;

  @override
  void initState() {
    super.initState();
    final initialPhone = widget.customerPhone ?? '';
    controller = CustomerLedgerController(customerPhone: initialPhone);
    _pageController = PageController(initialPage: controller.selectedTabIndex);
    
    // Hive रिएक्टिव कंट्रोलर को केवल फोन और फॉर्मेटर की आवश्यकता है
    _cashLoanController = CashLoanSectionController(
      customerPhone: initialPhone,
      formatAmount: controller.formatAmount,
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
        _cashLoanController.loadFromHive();
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cashLoanController.dispose();
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
                  arguments: {'customerPhone': controller.customerPhone},
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
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
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
                    onTabSelected: (idx) {
                      if (controller.selectedTabIndex != idx) {
                        controller.setTabIndex(idx);
                        _pageController.animateToPage(
                          idx,
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.fastOutSlowIn,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.72,
                    child: ScrollConfiguration(
                      behavior: WebAndMobileScrollBehavior(),
                      child: PageView(
                        controller: _pageController,
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        onPageChanged: (idx) {
                          if (controller.selectedTabIndex != idx) {
                            controller.setTabIndex(idx);
                          }
                        },
                        children: [
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: InstallmentSectionUi(controller: controller),
                          ),
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: CashLoanSectionPage(
                              controller: _cashLoanController,
                              customerProducts: controller.customerProducts,
                            ),
                          ),
                        ],
                      ),
                    ),
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