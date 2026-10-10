import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/shared/customer_session_context_service.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/main_dashboard/services/ledger_calculation_service.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/main_dashboard/services/ledger_action_handler_service.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_subview/services/installment_ledger_service.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_subview/services/ledger_math_service.dart';

class CustomerLedgerController extends ChangeNotifier {
  String customerPhone;
  int selectedTabIndex = 0;
  int selectedProductIndex = 0;
  bool isLoading = true;

  List<Map<String, dynamic>> customerProducts = [];
  int cashLoanBalance = 50000;
  List<Map<String, dynamic>> cashLoanEntries = LedgerActionHandlerService.initialCashLoanEntries;
  List<Map<String, dynamic>> serviceTransactions = LedgerActionHandlerService.initialServiceTransactions;

  CustomerLedgerController({this.customerPhone = ''}) {
    _initialize();
  }

  Future<void> _initialize() async {
    customerPhone = await CustomerSessionContextService.resolveActivePhone(fallbackPhone: customerPhone);
    await InstallmentLedgerService.ensureBoxOpen();
    InstallmentLedgerService.boxListenable?.addListener(loadCustomerData);
    await loadCustomerData();
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    InstallmentLedgerService.boxListenable?.removeListener(loadCustomerData);
    super.dispose();
  }

  Future<void> loadCustomerData() async {
    customerProducts = await InstallmentLedgerService.getCustomerInstallmentOrders(customerPhone);
    if (selectedProductIndex >= customerProducts.length) selectedProductIndex = 0;
    notifyListeners();
  }

  // گیٹرز
  int get totalInstallmentDue => LedgerCalculationService.calculateTotalInstallmentDue(customerProducts);
  int get pendingServiceCredit => LedgerCalculationService.calculatePendingServiceCredit(serviceTransactions);
  int get approvedServiceCredit => LedgerCalculationService.calculateApprovedServiceCredit(serviceTransactions);
  int get grandNetTotal => LedgerCalculationService.calculateGrandNetTotal(
        installmentDue: totalInstallmentDue,
        cashLoanBalance: cashLoanBalance,
        approvedServiceCredit: approvedServiceCredit,
      );
  String formatAmount(int amount) => LedgerMathService.formatAmount(amount);

  // اسٹیٹ اپڈیٹرز
  void setTabIndex(int index) { selectedTabIndex = index; notifyListeners(); }
  void setProductIndex(int index) { selectedProductIndex = index; notifyListeners(); }
  void toggleTransactionExpand(Map<String, dynamic> item) {
    item['isExpanded'] = !(item['isExpanded'] ?? false);
    notifyListeners();
  }

  void openPurchasePage(BuildContext context) =>
      Navigator.pushNamed(context, AppRoutes.purchaseMarket, arguments: {'customerPhone': customerPhone});

  // 1. کسٹمر پاس بک و رسیدیں کھولنا
  Future<void> openCustomerStatement(BuildContext context) =>
      LedgerActionHandlerService.openCustomerStatement(context, customerPhone, formatAmount);

  // 2. قسط کی ادائیگی کا ہینڈلر
  Future<void> handleInstallmentPayment(
    BuildContext context,
    Map<String, dynamic> schedItem, {
    String? itemName,
    String? planTitle,
  }) async {
    final ok = await LedgerActionHandlerService.payInstallment(
      context,
      this,
      schedItem,
      itemName: itemName,
      planTitle: planTitle,
    );
    if (ok) await loadCustomerData();
  }

  // 3. نقد ادھار واپسی کا ہینڈلر
  Future<void> handleCashLoanRepayment(BuildContext context) async {
    final ok = await LedgerActionHandlerService.payCashLoan(context, this);
    if (ok) notifyListeners();
  }
}