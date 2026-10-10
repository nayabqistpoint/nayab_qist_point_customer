class TransferInstallmentsBoxBuilder {
  /// installmentsBox کے اندر مخصوص پروڈکٹ کی قسطیں واٹر فال انداز میں ایڈجسٹ کرنا
  static Map<String, dynamic> build({
    required Map<String, dynamic> existingProductDoc,
    required int transferAmount,
  }) {
    // یہاں پچھلے ڈاکومنٹ کو لے کر اس میں سے قسطیں مائنس کر کے اپ ڈیٹڈ ڈاکیومنٹ ریٹرن ہوگا
    final int currentRemaining = (existingProductDoc['remaining'] as int?) ?? 0;
    final int newRemaining = (currentRemaining - transferAmount).clamp(0, currentRemaining);

    return {
      ...existingProductDoc,
      'remaining': newRemaining,
      'lastPaymentDate': DateTime.now().toIso8601String(),
    };
  }
}