class UniversalPaymentArgs {
  final String title;
  final int baseAmount;
  final bool isInstallment;
  final String? itemName;
  final String? planTitle;
  final int? installmentNo;
  final int? maxAllowedAmount;
  final String? customerPhone;

  const UniversalPaymentArgs({
    required this.title,
    required this.baseAmount,
    required this.isInstallment,
    this.itemName,
    this.planTitle,
    this.installmentNo,
    this.maxAllowedAmount,
    this.customerPhone,
  });

  factory UniversalPaymentArgs.fromMap(Map<String, dynamic>? map) {
    return UniversalPaymentArgs(
      title: map?['title']?.toString() ?? 'ادائیگی رسید',
      baseAmount: (map?['baseAmount'] as num?)?.toInt() ?? 0,
      isInstallment: map?['isInstallment'] == true,
      itemName: map?['itemName']?.toString(),
      planTitle: map?['planTitle']?.toString(),
      installmentNo: (map?['installmentNo'] as num?)?.toInt(),
      maxAllowedAmount: (map?['maxAllowedAmount'] as num?)?.toInt(),
      customerPhone: map?['customerPhone']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'baseAmount': baseAmount,
      'isInstallment': isInstallment,
      'itemName': itemName,
      'planTitle': planTitle,
      'installmentNo': installmentNo,
      'maxAllowedAmount': maxAllowedAmount,
      'customerPhone': customerPhone,
    };
  }
}

class UniversalPaymentResult {
  final int targetPayable;
  final int paid;
  final int discount;
  final int extra;
  final List<Map<String, dynamic>> splits;
  final String note;
  final String receiptImagePath;
  final String voiceNotePath;
  final bool hasPhoto;
  final bool hasAudio;

  const UniversalPaymentResult({
    required this.targetPayable,
    required this.paid,
    required this.discount,
    required this.extra,
    required this.splits,
    required this.note,
    required this.receiptImagePath,
    required this.voiceNotePath,
    required this.hasPhoto,
    required this.hasAudio,
  });

  Map<String, dynamic> toMap() {
    return {
      'targetPayable': targetPayable,
      'paid': paid,
      'discount': discount,
      'extra': extra,
      'splits': splits,
      'note': note,
      'receiptImagePath': receiptImagePath,
      'voiceNotePath': voiceNotePath,
      'hasPhoto': hasPhoto,
      'hasAudio': hasAudio,
    };
  }
}