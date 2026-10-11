class TransferTransactionBoxBuilder {
  static Map<String, dynamic> build({
    required String customerPhone,
    required String productName,
    required int transferAmount,
  }) {
    final now = DateTime.now();
    final String nowIso = now.toIso8601String();
    final String txId = 'TX-TRANSFER-${now.millisecondsSinceEpoch}';

    return {
      'docId': txId,
      'txId': txId,
      'customerPhone': customerPhone,
      'txType': 'TRANSFER_TO_INSTALLMENT',
      'title': 'نقد ایڈوانس سے قسط منتقلی ($productName)',
      'amount': transferAmount,
      'type': 'DEBIT',
      'txColor': 'RED', // 🔴 نقد کھاتے سے کٹوتی
      'status': 'PENDING',
      'date': '${now.day} اکتوبر ${now.year}',
      'createdAt': nowIso,
      'updatedAt': nowIso,
      'isSynced': false, // ☁️ سنک ٹریگر
      'hasPhoto': false,
      'hasAudio': false,
    };
  }
}