class CustomerLoginArgs {
  final String? initialPhone;

  const CustomerLoginArgs({this.initialPhone});

  Map<String, dynamic> toMap() {
    return {
      'initialPhone': initialPhone,
    };
  }

  factory CustomerLoginArgs.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const CustomerLoginArgs();
    return CustomerLoginArgs(
      initialPhone: map['initialPhone']?.toString(),
    );
  }
}