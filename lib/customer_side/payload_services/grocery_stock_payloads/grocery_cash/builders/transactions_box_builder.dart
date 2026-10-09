class TransactionsBoxBuilder {
  static Map<String, dynamic> buildGroceryTransaction({
    required String customerPhone,
    required List<Map<String, dynamic>> items,
    required int totalAmount,
    required String note,
    required bool hasPhoto,
    required bool hasAudio,
  }) {
    final now = DateTime.now();
    final String formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final String txId = 'TX-GROC-${now.millisecondsSinceEpoch}';

    return {
      'txId': txId,
      'customerPhone': customerPhone,
      'title': 'کریانہ راشن بل (نقد اندراج)',
      'type': 'GROCERY_EXPENSE',
      'targetAccount': 'نقد / دستی پیشگی کھاتہ',
      'date': formattedDate,
      'totalAmount': totalAmount,
      'items': items.map((item) => {
        'name': item['name'],
        'qty': item['qty'],
        'rate': item['unitPrice'] ?? item['amount'],
        'amount': item['amount'],
      }).toList(),
      'note': note.trim(),
      'hasPhoto': hasPhoto,
      'hasAudio': hasAudio,
      'status': 'PENDING',
      'isSynced': false,
      'createdAt': now.toIso8601String(),
    };
  }
}