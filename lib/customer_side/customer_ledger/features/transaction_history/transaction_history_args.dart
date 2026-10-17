class TransactionHistoryArgs {
  final String customerPhone;
  final String? initialFilter;

  const TransactionHistoryArgs({
    required this.customerPhone,
    this.initialFilter,
  });

  factory TransactionHistoryArgs.fromMap(Map<String, dynamic>? map) {
    return TransactionHistoryArgs(
      customerPhone: map?['customerPhone']?.toString() ?? '',
      initialFilter: map?['initialFilter']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerPhone': customerPhone,
      'initialFilter': initialFilter,
    };
  }
}