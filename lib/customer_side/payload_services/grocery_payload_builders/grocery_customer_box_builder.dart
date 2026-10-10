class GroceryCustomerBoxBuilder {
  static Map<String, dynamic> build({
    required int currentCashLoanBalance,
    required int currentInstallmentDue,
    required int grandTotal,
  }) {
    final int newCashBal = currentCashLoanBalance - grandTotal;
    final int newNetTotal = newCashBal + currentInstallmentDue;
    final nowIso = DateTime.now().toIso8601String();

    return {
      'cashLoanBalance': newCashBal,
      'installmentDueBalance': currentInstallmentDue,
      'grandNetTotal': newNetTotal,
      'updatedAt': nowIso,
      'lastUpdated': nowIso,
      'isSynced': false, // ☁️ سنک ٹریگر
    };
  }
}