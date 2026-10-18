class PurchaseMarketArgs {
  final String? customerPhone;

  const PurchaseMarketArgs({this.customerPhone});

  Map<String, dynamic> toMap() {
    return {
      'customerPhone': customerPhone,
    };
  }

  factory PurchaseMarketArgs.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const PurchaseMarketArgs();
    return PurchaseMarketArgs(
      customerPhone: map['customerPhone']?.toString(),
    );
  }
}