class ShopShowcaseArgs {
  final String? customerPhone;

  const ShopShowcaseArgs({this.customerPhone});

  Map<String, dynamic> toMap() {
    return {
      'customerPhone': customerPhone,
    };
  }

  factory ShopShowcaseArgs.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const ShopShowcaseArgs();
    return ShopShowcaseArgs(
      customerPhone: map['customerPhone']?.toString(),
    );
  }
}