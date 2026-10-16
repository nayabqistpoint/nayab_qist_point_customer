import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_subview/installment_args.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_subview/services/installment_ledger_service.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_subview/services/installment_storage_handler.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_subview/services/ledger_math_service.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/shared/customer_session_context_service.dart';

class InstallmentSectionController extends ChangeNotifier {
  final InstallmentArgs args;

  InstallmentSectionController({required this.args}) {
    loadInstallmentData();
  }

  bool isLoading = false;
  int selectedProductIndex = 0;
  List<Map<String, dynamic>> customerProducts = [];

  ValueListenable<Box>? get boxListenable => InstallmentStorageHandler.installmentsListenable;

  Future<void> loadInstallmentData() async {
    isLoading = true;
    notifyListeners();
    try {
      final orders = await InstallmentLedgerService.getCustomerInstallmentOrders(args.customerPhone);
      customerProducts = orders;
      if (selectedProductIndex >= customerProducts.length) {
        selectedProductIndex = 0;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setProductIndex(int index) {
    if (index >= 0 && index < customerProducts.length) {
      selectedProductIndex = index;
      notifyListeners();
    }
  }

  Map<String, dynamic> get currentProduct {
    if (customerProducts.isEmpty) return {};
    final idx = selectedProductIndex;
    return (idx >= 0 && idx < customerProducts.length) ? customerProducts[idx] : customerProducts.first;
  }

  List<Map<String, dynamic>> get currentSchedule {
    final prod = currentProduct;
    return (prod['schedule'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }

  Map<String, dynamic> get currentOverdueSummary {
    return LedgerMathService.calculateOverdueSummary(currentSchedule);
  }

  int? get activePayableInstallmentNo {
    final prod = currentProduct;
    final bool hasPendingReview = prod['hasPendingReview'] == true;
    if (hasPendingReview) return null;

    for (final item in currentSchedule) {
      final int remaining = (item['remainingAmount'] as int?) ?? 0;
      final bool isPaid = item['isApproved'] == true && remaining <= 0;
      if (!isPaid && remaining > 0) {
        return item['no'] as int?;
      }
    }
    return null;
  }

  String formatAmount(int amount) => LedgerMathService.formatAmount(amount);

  Future<void> handleInstallmentPayment(
    BuildContext context,
    Map<String, dynamic> item, {
    required String itemName,
    required String planTitle,
  }) async {
    final prod = currentProduct;
    final int remaining = (item['remainingAmount'] as int?) ?? (item['amount'] as int? ?? 0);
    final int totalRemaining = (prod['remaining'] as int?) ?? remaining;

    // آزاد نیویگیشن: صرف پیمنٹ شیٹ کھلے گی اور بند ہوگی، واپسی کے رزلٹ کا کوئی انتظار نہیں
    await CustomerSessionContextService.openUniversalPayment(
      context,
      title: 'قسط نمبر ${item['no']} کی ادائیگی',
      baseAmount: remaining,
      isInstallment: true,
      itemName: itemName,
      planTitle: planTitle,
      installmentNo: item['no'] as int?,
      maxAllowedAmount: totalRemaining,
    );
  }
}