import 'dart:async';
import 'package:flutter/material.dart';
import 'services/cash_loan_calculation_service.dart';
import 'services/cash_loan_storage_handler.dart';

class CashAccountController extends ChangeNotifier {
  final String customerPhone;
  int cashLoanBalance = 0;
  List<Map<String, dynamic>> cashLoanEntries = [];
  List<Map<String, dynamic>> customerProducts = [];
  final Set<int> _expandedIndices = {};
  List<StreamSubscription> _subscriptions = [];

  CashAccountController({
    required this.customerPhone,
  }) {
    _initDataAndListeners();
  }

  Set<int> get expandedIndices => _expandedIndices;

  Future<void> _initDataAndListeners() async {
    await loadFromHive();
    _subscriptions = await CashLoanStorageHandler.watchCashLoanChanges(
      customerPhone: customerPhone,
      onDataChanged: loadFromHive,
    );
  }

  Future<void> loadFromHive() async {
    final result = await CashLoanStorageHandler.loadCashLoanData(customerPhone);
    cashLoanBalance = result['balance'] as int;
    cashLoanEntries = result['entries'] as List<Map<String, dynamic>>;
    notifyListeners();
  }

  List<Map<String, dynamic>> get computedEntries {
    return CashLoanCalculationService.computeHistoricalRunningBalances(
      currentCashLoanBalance: cashLoanBalance,
      rawEntries: cashLoanEntries,
    );
  }

  void toggleAccordion(int index) {
    if (_expandedIndices.contains(index)) {
      _expandedIndices.remove(index);
    } else {
      _expandedIndices.add(index);
    }
    notifyListeners();
  }

  String formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  void dispose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}