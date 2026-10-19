class TransferToInstallmentArgs {
  final String customerPhone;
  final List<Map<String, dynamic>> products;
  final int availableGreenAdvance;

  const TransferToInstallmentArgs({
    required this.customerPhone,
    required this.products,
    this.availableGreenAdvance = 0,
  });

  factory TransferToInstallmentArgs.fromMap(Map<String, dynamic>? map) {
    return TransferToInstallmentArgs(
      customerPhone: map?['customerPhone']?.toString() ?? '',
      products: (map?['products'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      availableGreenAdvance: (map?['availableGreenAdvance'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerPhone': customerPhone,
      'products': products,
      'availableGreenAdvance': availableGreenAdvance,
    };
  }
}

class TransferToInstallmentResult {
  final bool isSuccess;
  final int transferredAmount;

  const TransferToInstallmentResult({
    required this.isSuccess,
    required this.transferredAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'isSuccess': isSuccess,
      'transferredAmount': transferredAmount,
    };
  }
}