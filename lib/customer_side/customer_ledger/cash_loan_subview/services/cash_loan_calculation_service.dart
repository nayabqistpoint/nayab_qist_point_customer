class CashLoanCalculationService {
  /// تاریخ وار ہر ٹرانزیکشن کا رننگ بیلنس حساب کرنا
  static List<Map<String, dynamic>> computeHistoricalRunningBalances({
    required int currentCashLoanBalance,
    required List<Map<String, dynamic>> rawEntries,
  }) {
    int running = currentCashLoanBalance;
    final List<Map<String, dynamic>> result = [];

    for (int i = 0; i < rawEntries.length; i++) {
      final entry = Map<String, dynamic>.from(rawEntries[i]);
      final int amt = (entry['amount'] as num?)?.toInt() ?? 0;
      final String type = (entry['type'] ?? 'DEBIT').toString().toUpperCase();

      entry['runningBalanceAtThisPoint'] = running;
      result.add(entry);

      // پچھلی تاریخ کے لیے ریورس بیلنس نکالنا
      if (type == 'DEBIT') {
        running -= amt;
      } else {
        running += amt;
      }
    }
    return result;
  }
}