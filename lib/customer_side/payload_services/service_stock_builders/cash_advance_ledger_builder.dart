class CashAdvanceLedgerBuilder {
  static Map<String, dynamic> buildAdvanceLedgerAdjustment({
    required String activePhone,
    required int amount,
    required String note,
  }) {
    return {
      'phone': activePhone,
      'type': 'ADVANCE_DEPOSIT_RATION',
      'amount': amount,
      'note': note,
      'isSynced': false,
      'syncStatus': 'PENDING',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}