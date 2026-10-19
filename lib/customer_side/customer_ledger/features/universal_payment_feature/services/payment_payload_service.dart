class PaymentPayloadService {
  PaymentPayloadService._();

  static Map<String, dynamic> buildPaymentResultMap({
    required int targetPayable,
    required int splitsSum,
    required int discountAmount,
    required List<Map<String, dynamic>> splits,
    required String note,
    required String receiptImagePath,
    required String voiceNotePath,
    required bool hasPhoto,
    required bool hasAudio,
  }) {
    return {
      'targetPayable': targetPayable,
      'paid': splitsSum,
      'discount': discountAmount,
      'extra': 0,
      'splits': splits,
      'note': note,
      'receiptImagePath': receiptImagePath,
      'voiceNotePath': voiceNotePath,
      'hasPhoto': hasPhoto,
      'hasAudio': hasAudio,
    };
  }
}