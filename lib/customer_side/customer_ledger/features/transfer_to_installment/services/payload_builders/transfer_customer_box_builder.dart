class TransferCustomerBoxBuilder {
  TransferCustomerBoxBuilder._();

  static Map<String, dynamic> build({
    required Map<String, dynamic> existingCustomerDoc,
    required int transferAmount,
  }) {
    final String nowIso = DateTime.now().toIso8601String();
    final int oldCashBal = (existingCustomerDoc['cashLoanBalance'] as num?)?.toInt() ?? 0;
    final int oldInstBal = (existingCustomerDoc['installmentDueBalance'] as num?)?.toInt() ?? 0;
    
    final int newCashBal = oldCashBal + transferAmount;
    final int newInstBal = (oldInstBal - transferAmount).clamp(0, oldInstBal);

    return {
      ...existingCustomerDoc,
      'cashLoanBalance': newCashBal,
      'installmentDueBalance': newInstBal,
      'grandNetTotal': newCashBal + newInstBal,
      'updatedAt': nowIso,
      'lastUpdated': nowIso,
      'isSynced': false,
    };
  }
}