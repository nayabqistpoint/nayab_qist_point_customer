class CashLoanTransactionBuilder {
  static Map<String, dynamic> buildTransactionRecord({
    required String customerPhone,
    required int paidAmount,
    required int discountAmount,
    required List<Map<String, dynamic>> splits,
    required String note,
    String receiptImagePath = '',
    String voiceNotePath = '',
  }) {
    final String timestampId = DateTime.now().millisecondsSinceEpoch.toString();
    final String txnId = 'TXN-LOAN-$timestampId';
    final String nowIso = DateTime.now().toIso8601String();

    return {
      'txId': txnId,
      'customerPhone': customerPhone,
      'orderDocId': 'CASH_LOAN_ACCOUNT',
      'title': 'نقد دستی ادھار واپسی جمع',
      'itemName': 'نقد دستی ادھار کھاتہ',
      'planTitle': 'دستی قرض کھاتہ',
      'type': 'CASH_LOAN_CREDIT',
      'totalPaid': paidAmount,
      'discount': discountAmount,
      'extra': 0,
      'splits': List<Map<String, dynamic>>.from(splits),
      'allocationSummary': [
        'نقد دستی قرض واپسی وصولی: Rs. $paidAmount',
        if (discountAmount > 0) 'رعایت / چھوٹ: Rs. $discountAmount',
      ],
      'note': note.trim(),
      'receiptImagePath': receiptImagePath,
      'voiceNotePath': voiceNotePath,
      'hasPhoto': receiptImagePath.isNotEmpty,
      'hasAudio': voiceNotePath.isNotEmpty,
      'date': nowIso,
      'paymentDate': nowIso,
      'verificationStatus': 'UNDER_REVIEW',
      'isSynced': false,
    };
  }
}