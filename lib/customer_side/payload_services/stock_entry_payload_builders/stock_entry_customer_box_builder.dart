class StockEntryCustomerBoxBuilder {
  /// customerBox کے اندر نقد ادھار اپ ڈیٹ کرنا
  static Map<String, dynamic> build({
    required int currentCashLoanBalance,
    required int purchasePrice,
    required bool isPromotionalOnOrder,
  }) {
    final int deduction = isPromotionalOnOrder ? 0 : purchasePrice;
    return {
      'cashLoanBalance': currentCashLoanBalance - deduction,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }
}