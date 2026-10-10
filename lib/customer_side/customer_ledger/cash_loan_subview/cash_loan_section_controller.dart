import 'dart:async';
import 'package:flutter/material.dart';
import 'services/cash_loan_calculation_service.dart';
import '../../hive_services/hive_box_manager.dart';

class CashLoanSectionController extends ChangeNotifier {
  final String customerPhone;
  final String Function(int) formatAmount;

  int cashLoanBalance = 0;
  List<Map<String, dynamic>> cashLoanEntries = [];
  final Set<int> _expandedIndices = {};

  StreamSubscription? _txSubscription;
  StreamSubscription? _custSubscription;

  CashLoanSectionController({
    required this.customerPhone,
    required this.formatAmount,
  }) {
    _initHiveListeners();
  }

  Set<int> get expandedIndices => _expandedIndices;

  /// ہائیو باکسز سے خودکار سننا (Reactive Live Stream)
  Future<void> _initHiveListeners() async {
    await loadFromHive();

    final txBox = await HiveBoxManager.openSafeBox(HiveBoxManager.transactionBoxName);
    _txSubscription = txBox.watch().listen((_) => loadFromHive());

    final custBox = await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);
    _custSubscription = custBox.watch(key: customerPhone).listen((_) => loadFromHive());
  }

  /// ہائیو سے تمام کسٹمر ٹرانزیکشنز اور بیلنس لوڈ کرنا
  Future<void> loadFromHive() async {
    final custBox = await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);
    final custData = custBox.get(customerPhone);
    if (custData is Map) {
      cashLoanBalance = (custData['cashLoanBalance'] as num?)?.toInt() ?? 0;
    }

    final txBox = await HiveBoxManager.openSafeBox(HiveBoxManager.transactionBoxName);
    final List<Map<String, dynamic>> list = [];

    for (var val in txBox.values) {
      if (val is Map && val['customerPhone'] == customerPhone) {
        list.add(Map<String, dynamic>.from(val));
      }
    }

    // تاریخ وار ترتیب (نیا ریکارڈ سب سے اوپر)
    list.sort((a, b) {
      final tA = a['timestamp']?.toString() ?? '';
      final tB = b['timestamp']?.toString() ?? '';
      return tB.compareTo(tA);
    });

    cashLoanEntries = list;
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
    _txSubscription?.cancel();
    _custSubscription?.cancel();
    super.dispose();
  }
}