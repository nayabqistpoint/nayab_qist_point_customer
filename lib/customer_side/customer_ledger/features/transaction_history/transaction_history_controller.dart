import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'transaction_history_args.dart';
import 'services/transaction_history_service.dart';

class TransactionHistoryController extends ChangeNotifier {
  final TransactionHistoryArgs args;

  bool isLoading = true;
  int selectedFilterIndex = 0;
  List<Map<String, dynamic>> allTransactions = [];

  TransactionHistoryController({required this.args}) {
    _init();
  }

  ValueListenable<Box>? get boxListenable => TransactionHistoryService.boxListenable;

  Future<void> _init() async {
    isLoading = true;
    notifyListeners();
    await loadTransactions();
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadTransactions() async {
    allTransactions = await TransactionHistoryService.getCustomerTransactions(args.customerPhone);
    notifyListeners();
  }

  void setFilter(int index) {
    selectedFilterIndex = index;
    notifyListeners();
  }

  List<Map<String, dynamic>> get filteredTransactions {
    if (selectedFilterIndex == 0) return allTransactions;

    if (selectedFilterIndex == 1) {
      return allTransactions.where((t) {
        final String type = (t['type'] ?? t['txType'] ?? '').toString().toUpperCase();
        final String orderDocId = (t['orderDocId'] ?? '').toString();
        return type.contains('INSTALLMENT') || orderDocId != 'CASH_LOAN_ACCOUNT';
      }).toList();
    }

    if (selectedFilterIndex == 2) {
      return allTransactions.where((t) {
        final String type = (t['type'] ?? t['txType'] ?? '').toString().toUpperCase();
        final String orderDocId = (t['orderDocId'] ?? '').toString();
        return type.contains('CASH') ||
            type.contains('GROCERY') ||
            type.contains('STOCK') ||
            orderDocId == 'CASH_LOAN_ACCOUNT';
      }).toList();
    }

    if (selectedFilterIndex == 3) {
      return allTransactions.where((t) {
        final String vStatus = (t['verificationStatus'] ?? 'UNDER_REVIEW').toString().toUpperCase();
        return vStatus != 'APPROVED' && vStatus != 'VERIFIED';
      }).toList();
    }

    return allTransactions;
  }

  String formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}