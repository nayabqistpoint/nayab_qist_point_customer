class GroceryTransactionBoxBuilder {
  static Map<String, dynamic> build({
    required String customerPhone,
    required int grandTotal,
    required List<Map<String, dynamic>> items,
    required bool hasPhoto,
    required bool hasAudio,
  }) {
    final now = DateTime.now();
    final String nowIso = now.toIso8601String();
    final String txId = 'TX-GROCERY-${now.millisecondsSinceEpoch}';

    return {
      'docId': txId,
      'txId': txId,
      'customerPhone': customerPhone,
      'txType': 'GROCERY',
      'title': 'ماہانہ کریانہ راشن بل کٹوتی',
      'amount': grandTotal,
      'type': 'CREDIT',
      'txColor': 'GREEN', // 🟢 آسان اور واضح کلر
      'status': 'PENDING',
      'date': '${now.day} اکتوبر ${now.year}',
      'createdAt': nowIso,
      'updatedAt': nowIso,
      'isSynced': false, // ☁️ سنک ٹریگر
      'hasPhoto': hasPhoto,
      'hasAudio': hasAudio,
      'items': items,
    };
  }
}