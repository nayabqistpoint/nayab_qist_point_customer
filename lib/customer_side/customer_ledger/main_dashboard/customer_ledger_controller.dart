import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_subview/installment_args.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_subview/installment_section_controller.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_subview/installment_section_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_subview/services/installment_ledger_service.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_subview/services/ledger_math_service.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/cash_loan_subview/cash_loan_section_controller.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/cash_loan_subview/cash_loan_section_page.dart';
import 'services/ledger_action_handler_service.dart';

class CustomerLedgerController extends ChangeNotifier {
  String customerPhone;
  bool isLoading = true;

  // اقساط کھاتہ ڈیٹا
  List<Map<String, dynamic>> customerProducts = [];
  int totalInstallmentDue = 0;
  int overdueInstallmentCount = 0;
  int overdueInstallmentAmount = 0;
  String activeMobileTitle = 'کوئی فعال پلان نہیں';
  String activePlanSubtitle = 'اقساط پلان';

  // نقد کھاتہ ڈیٹا
  int cashLoanBalance = 0;

  CustomerLedgerController({this.customerPhone = ''}) {
    initialize();
  }

  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();

    if (customerPhone.trim().isEmpty) {
      customerPhone = await _resolveActivePhone();
    }

    await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);
    await HiveBoxManager.openSafeBox(HiveBoxManager.installmentsBoxName);

    await refreshDashboardData();
    isLoading = false;
    notifyListeners();
  }

  Future<String> _resolveActivePhone() async {
    try {
      final settingsBox = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
      final phone = settingsBox.get('activePhone') ??
          settingsBox.get('remembered_phone') ??
          settingsBox.get('last_logged_phone');
      if (phone != null && phone.toString().trim().isNotEmpty) {
        return phone.toString().trim();
      }
    } catch (_) {}
    return '';
  }

  Future<void> refreshDashboardData() async {
    if (customerPhone.trim().isEmpty) return;

    // 1. اقساط ڈیٹا لوڈ کریں
    customerProducts = await InstallmentLedgerService.getCustomerInstallmentOrders(customerPhone);
    totalInstallmentDue = 0;
    overdueInstallmentCount = 0;
    overdueInstallmentAmount = 0;

    if (customerProducts.isNotEmpty) {
      final firstProd = customerProducts.first;
      activeMobileTitle = firstProd['name']?.toString() ?? 'موبائل فون';
      activePlanSubtitle = firstProd['plan']?.toString() ?? 'اقساط پلان';

      for (var prod in customerProducts) {
        totalInstallmentDue += (prod['remaining'] as int?) ?? 0;
        final schedule = (prod['schedule'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        final overdue = LedgerMathService.calculateOverdueSummary(schedule);
        overdueInstallmentCount += (overdue['count'] as int?) ?? 0;
        overdueInstallmentAmount += (overdue['amount'] as int?) ?? 0;
      }
    } else {
      activeMobileTitle = 'کوئی فعال پلان نہیں';
      activePlanSubtitle = '0 اقساط';
    }

    // 2. نقد کھاتہ بیلنس لوڈ کریں
    final custBox = await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);
    final custData = custBox.get(customerPhone);
    if (custData is Map) {
      cashLoanBalance = (custData['cashLoanBalance'] as num?)?.toInt() ?? 0;
    } else {
      cashLoanBalance = 0;
    }

    notifyListeners();
  }

  int get grandNetTotal => totalInstallmentDue + cashLoanBalance;
  bool get isDebtor => grandNetTotal >= 0;
  bool get hasAdvance => cashLoanBalance < 0;

  String formatAmount(int amount) => LedgerMathService.formatAmount(amount);

  // 🎯 اقساط کھاتہ پیج کھولیں (فل اسکرین نیویگیشن)
  void openInstallmentPage(BuildContext context) async {
    final instController = InstallmentSectionController(
      args: InstallmentArgs(customerPhone: customerPhone),
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              backgroundColor: const Color(0xFF0F172A),
              title: const Text(
                'اقساط کھاتہ تفصیلات',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: InstallmentSectionUi(controller: instController),
            ),
          ),
        ),
      ),
    );

    instController.dispose();
    await refreshDashboardData();
  }

  // 🎯 نقد کھاتہ پیج کھولیں (فل اسکرین نیویگیشن)
  void openCashLoanPage(BuildContext context) async {
    final cashController = CashLoanSectionController(
      customerPhone: customerPhone,
      formatAmount: formatAmount,
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              backgroundColor: const Color(0xFF0F172A),
              title: const Text(
                'نقد کھاتہ تفصیلات',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: CashLoanSectionPage(
                controller: cashController,
                customerProducts: customerProducts,
              ),
            ),
          ),
        ),
      ),
    );

    cashController.dispose();
    await refreshDashboardData();
  }

  void openPurchaseMarket(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.purchaseMarket,
      arguments: {'customerPhone': customerPhone},
    );
  }

  void openStatementSheet(BuildContext context) {
    LedgerActionHandlerService.openCustomerStatement(context, customerPhone, formatAmount);
  }
}