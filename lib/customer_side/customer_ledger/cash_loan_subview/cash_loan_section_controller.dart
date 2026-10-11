import 'dart:async';
import 'package:flutter/material.dart';
import 'services/cash_loan_calculation_service.dart';
import 'services/cash_loan_storage_handler.dart';

class CashLoanSectionController extends ChangeNotifier {
  final String customerPhone;
  final String Function(int) formatAmount;

  int cashLoanBalance = 0;
  List<Map<String, dynamic>> cashLoanEntries = [];
  final Set<int> _expandedIndices = {};
  List<StreamSubscription> _subscriptions = [];

  CashLoanSectionController({
    required this.customerPhone,
    required this.formatAmount,
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

  /// ہائیو سے تازہ ڈیٹا لوڈ کرنا
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

  @override
  void dispose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}