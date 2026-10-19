import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';
import 'customer_ledger_args.dart';
import 'services/ledger_storage_handler.dart';
import 'services/ledger_calculation_service.dart';

class CustomerLedgerController extends ChangeNotifier {
  final CustomerLedgerArgs args;
  String customerPhone;
  bool isLoading = true;

  int totalInstallmentDue = 0;
  int overdueInstallmentCount = 0;
  int overdueInstallmentAmount = 0;
  String activeMobileTitle = 'کوئی فعال پلان نہیں';
  String activePlanSubtitle = 'اقساط پلان';
  int cashLoanBalance = 0;

  CustomerLedgerController({required this.args})
      : customerPhone = args.customerPhone {
    initialize();
  }

  int get grandNetTotal =>
      LedgerCalculationService.calculateGrandNetTotal(
        installmentDue: totalInstallmentDue,
        cashLoanBalance: cashLoanBalance,
      );

  bool get isDebtor => grandNetTotal >= 0;
  bool get hasAdvance => cashLoanBalance < 0;

  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();

    await LedgerStorageHandler.ensureRequiredBoxesOpen();

    if (customerPhone.trim().isEmpty) {
      customerPhone = await LedgerStorageHandler.resolveActivePhone();
    }

    await refreshDashboardData();
    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshDashboardData() async {
    if (customerPhone.trim().isEmpty) return;

    final rawOrders = await LedgerStorageHandler.fetchRawInstallmentOrders(customerPhone);
    final summary = LedgerCalculationService.parseInstallmentsSummary(rawOrders);

    totalInstallmentDue = summary['totalDue'] as int;
    overdueInstallmentCount = summary['overdueCount'] as int;
    overdueInstallmentAmount = summary['overdueAmount'] as int;
    activeMobileTitle = summary['mobileTitle'] as String;
    activePlanSubtitle = summary['planSubtitle'] as String;

    cashLoanBalance = await LedgerStorageHandler.getCustomerCashBalance(customerPhone);

    notifyListeners();
  }

  String formatAmount(int amount) => LedgerCalculationService.formatAmount(amount);

  void openInstallmentPage(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.installmentAccount,
      arguments: {'customerPhone': customerPhone},
    );
  }

  void openCashLoanPage(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.cashAccount,
      arguments: {'customerPhone': customerPhone},
    );
  }

  void openPurchaseMarket(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.purchaseMarket,
      arguments: {'customerPhone': customerPhone},
    );
  }

  void openStatementSheet(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.transactionHistory,
      arguments: {'customerPhone': customerPhone},
    );
  }
}