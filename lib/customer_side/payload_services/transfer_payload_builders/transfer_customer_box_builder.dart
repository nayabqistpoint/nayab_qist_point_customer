class TransferCustomerBoxBuilder {
  /// customerBox کے اندر نقد ادھار کو ایڈجسٹ کرنا
  static Map<String, dynamic> build({
    required int currentCashLoanBalance,
    required int transferAmount,
  }) {
    return {
      'cashLoanBalance': currentCashLoanBalance - transferAmount,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }
}