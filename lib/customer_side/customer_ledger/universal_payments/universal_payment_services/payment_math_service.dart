class PaymentMathService {
  static String formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  static int splitsSum(List<Map<String, dynamic>> splits) {
    return splits.fold(0, (sum, item) => sum + ((item['amount'] as int?) ?? 0));
  }

  static int requiredCash({
    required int targetPayable,
    required int adjustmentAmount,
    required bool isIncome,
  }) {
    return isIncome ? (targetPayable + adjustmentAmount) : (targetPayable - adjustmentAmount);
  }

  static int difference({
    required int splitsSum,
    required int requiredCash,
  }) {
    return splitsSum - requiredCash;
  }

  static bool isReconciled({
    required int difference,
    required int splitsSum,
    required int adjustmentAmount,
  }) {
    return (difference == 0) && (splitsSum > 0 || adjustmentAmount > 0);
  }
}