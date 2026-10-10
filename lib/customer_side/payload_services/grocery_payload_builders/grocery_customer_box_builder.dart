class GroceryCustomerBoxBuilder {
  /// customerBox کے اندر نقد ادھار اپ ڈیٹ کرنا
  static Map<String, dynamic> build({
    required int currentCashLoanBalance,
    required int grandTotal,
  }) {
    return {
      'cashLoanBalance': currentCashLoanBalance - grandTotal,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }
}