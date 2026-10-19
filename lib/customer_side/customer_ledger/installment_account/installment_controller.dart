import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'installment_args.dart';
import 'services/installment_ledger_service.dart';
import 'services/installment_storage_handler.dart';
import 'services/ledger_math_service.dart';

class InstallmentController extends ChangeNotifier {
  final InstallmentArgs args;

  bool isLoading = false;
  int selectedProductIndex = 0;
  List<Map<String, dynamic>> customerProducts = [];

  InstallmentController({required this.args}) {
    loadInstallmentData();
  }

  ValueListenable<Box>? get boxListenable => InstallmentStorageHandler.installmentsListenable;

  Future<void> loadInstallmentData() async {
    isLoading = true;
    notifyListeners();
    try {
      final rawOrders = await InstallmentStorageHandler.fetchRawInstallmentOrders();
      customerProducts = InstallmentLedgerService.parseCustomerOrders(
        rawOrders: rawOrders,
        customerPhone: args.customerPhone,
      );
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
    if (customerProducts.isEmpty) return const {};
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
    if (prod['hasPendingReview'] == true) return null;
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
}