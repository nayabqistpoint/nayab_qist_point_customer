class CashAccountArgs {
  final String customerPhone;
  final String? customerName;

  const CashAccountArgs({
    required this.customerPhone,
    this.customerName,
  });

  factory CashAccountArgs.fromMap(Map<String, dynamic> map) {
    return CashAccountArgs(
      customerPhone: map['customerPhone']?.toString() ?? '',
      customerName: map['customerName']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerPhone': customerPhone,
      'customerName': customerName,
    };
  }
}