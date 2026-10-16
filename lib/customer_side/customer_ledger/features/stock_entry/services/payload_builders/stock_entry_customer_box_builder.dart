class StockEntryCustomerBoxBuilder {
  static Map<String, dynamic> build({
    required int currentCashLoanBalance,
    required int currentInstallmentDue,
    required int purchasePrice,
    required bool isPromotionalOnOrder,
  }) {
    final int deduction = isPromotionalOnOrder ? 0 : purchasePrice;
    final int newCashBal = currentCashLoanBalance - deduction;
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