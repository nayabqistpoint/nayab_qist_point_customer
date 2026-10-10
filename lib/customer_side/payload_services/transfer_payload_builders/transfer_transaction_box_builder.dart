class TransferTransactionBoxBuilder {
  /// transactionBox میں واؤچر کا نیا یونیک ڈاکومنٹ بنانا
  static Map<String, dynamic> build({
    required String customerPhone,
    required String productName,
    required int transferAmount,
  }) {
    final now = DateTime.now();
    return {
      'txId': 'TX-TRANSFER-${now.millisecondsSinceEpoch}',
      'customerPhone': customerPhone,
      'txType': 'TRANSFER_TO_INSTALLMENT',
      'title': 'نقد کھاتے سے قسط منتقلی ($productName)',
      'amount': transferAmount,
      'type': 'CREDIT',
      'date': '${now.day} اکتوبر ${now.year}',
      'timestamp': now.toIso8601String(),
      'hasPhoto': false,
      'hasAudio': false,
    };
  }
}