class CustomerLedgerArgs {
  final String customerPhone;
  final String? customerName;

  const CustomerLedgerArgs({
    required this.customerPhone,
    this.customerName,
  });

  factory CustomerLedgerArgs.fromMap(Map<String, dynamic>? map) {
    return CustomerLedgerArgs(
      customerPhone: map?['customerPhone']?.toString() ?? '',
      customerName: map?['customerName']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerPhone': customerPhone,
      'customerName': customerName,
    };
  }
}