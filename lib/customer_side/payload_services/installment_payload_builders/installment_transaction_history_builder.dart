// lib/customer_side/payload_services/installment_payload_builders/installment_transaction_history_builder.dart

class InstallmentTransactionHistoryBuilder {
  static Map<String, dynamic> buildTransactionRecord({
    required String customerPhone,
    required String orderDocId,
    required String itemName,
    required String planTitle,
    required int collectedTotal,
    required int discountAmount,
    required int extraAmount,
    required List<Map<String, dynamic>> splits,
    required List<String> allocationSummary,
    required String note,
    String receiptImagePath = '',
    String voiceNotePath = '',
  }) {
    final String timestampId = DateTime.now().millisecondsSinceEpoch.toString();
    final String txnId = 'TXN-$timestampId';

    return {
      'txId': txnId,
      'customerPhone': customerPhone,
      'orderDocId': orderDocId,
      'title': 'اقساط وصولی ($itemName)',
      'itemName': itemName,
      'planTitle': planTitle,
      'type': 'INSTALLMENT_COLLECTION',
      'totalPaid': collectedTotal,
      'discount': discountAmount,
      'extra': extraAmount,
      'splits': List<Map<String, dynamic>>.from(splits),
      'allocationSummary': allocationSummary,
      'note': note.trim(),
      'receiptImagePath': receiptImagePath,
      'voiceNotePath': voiceNotePath,
      'hasPhoto': receiptImagePath.isNotEmpty,
      'hasAudio': voiceNotePath.isNotEmpty,
      'date': DateTime.now().toIso8601String(),
      'verificationStatus': 'UNDER_REVIEW',
      'isSynced': false,
    };
  }
}