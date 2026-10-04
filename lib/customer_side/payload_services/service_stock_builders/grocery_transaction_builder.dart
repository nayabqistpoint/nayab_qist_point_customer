class GroceryTransactionBuilder {
  static Map<String, dynamic> buildTransactionRecord({
    required String txId,
    required String customerPhone,
    required String customerName,
    required int totalAmount,
    required List<Map<String, dynamic>> items,
    required String targetAccountTitle,
    required String note,
  }) {
    final now = DateTime.now();
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    return {
      'txId': txId,
      'docId': txId,
      'customerPhone': customerPhone,
      'customerName': customerName,
      'title': 'گھریلو راشن خریداری بل',
      'nature': 'EXPENSE',
      'natureTitle': 'دکان و راشن خرچہ',
      'totalAmount': totalAmount,
      'totalPaid': totalAmount,
      'discount': 0,
      'items': items,
      'targetAccount': targetAccountTitle,
      'note': note,
      'date': dateStr,
      'paymentDate': dateStr,
      'status': 'PENDING',
      'isSynced': false,
      'createdAt': now.toIso8601String(),
    };
  }
}