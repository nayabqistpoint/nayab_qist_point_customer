class CustomerSignupArgs {
  final String? initialPhone;

  const CustomerSignupArgs({this.initialPhone});

  Map<String, dynamic> toMap() {
    return {
      'initialPhone': initialPhone,
    };
  }

  factory CustomerSignupArgs.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const CustomerSignupArgs();
    return CustomerSignupArgs(
      initialPhone: map['initialPhone']?.toString(),
    );
  }
}