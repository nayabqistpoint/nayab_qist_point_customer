class GroceryTransactionBoxBuilder {
  /// transactionBox کے لیے نیا منفرد ڈاکومنٹ بنانا
  static Map<String, dynamic> build({
    required String customerPhone,
    required int grandTotal,
    required List<Map<String, dynamic>> items,
    required bool hasPhoto,
    required bool hasAudio,
  }) {
    final now = DateTime.now();
    final String txId = 'TX-GROCERY-${now.millisecondsSinceEpoch}';

    return {
      'txId': txId,
      'customerPhone': customerPhone,
      'txType': 'GROCERY',
      'title': 'ماہانہ کریانہ راشن بل کٹوتی',
      'amount': grandTotal,
      'type': 'CREDIT',
      'date': '${now.day} اکتوبر ${now.year}',
      'timestamp': now.toIso8601String(),
      'hasPhoto': hasPhoto,
      'hasAudio': hasAudio,
      'items': items,
    };
  }
}