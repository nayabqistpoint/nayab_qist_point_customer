import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'transaction_history_args.dart';
import 'services/transaction_history_service.dart';
import 'services/transaction_history_storage_handler.dart';

class TransactionHistoryController extends ChangeNotifier {
  final TransactionHistoryArgs args;
  bool isLoading = true;
  int selectedFilterIndex = 0;
  List<Map<String, dynamic>> allTransactions = [];

  TransactionHistoryController({required this.args}) {
    _init();
  }

  ValueListenable<Box>? get boxListenable => TransactionHistoryStorageHandler.boxListenable;

  Future<void> _init() async {
    isLoading = true;
    notifyListeners();
    await loadTransactions();
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadTransactions() async {
    final rawList = await TransactionHistoryStorageHandler.fetchRawTransactions();
    allTransactions = TransactionHistoryService.filterAndSortByCustomer(
      rawTransactions: rawList,
      customerPhone: args.customerPhone,
    );
    notifyListeners();
  }

  void setFilter(int index) {
    selectedFilterIndex = index;
    notifyListeners();
  }

  List<Map<String, dynamic>> get filteredTransactions {
    return TransactionHistoryService.applyFilterTab(
      transactions: allTransactions,
      filterIndex: selectedFilterIndex,
    );
  }

  String formatAmount(int amount) => TransactionHistoryService.formatAmount(amount);
}