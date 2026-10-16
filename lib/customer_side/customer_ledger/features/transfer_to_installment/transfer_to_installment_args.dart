class TransferToInstallmentArgs {
  final String customerPhone;
  final List<Map<String, dynamic>> products;

  const TransferToInstallmentArgs({
    required this.customerPhone,
    required this.products,
  });
}

class TransferToInstallmentResult {
  final bool isSuccess;
  final int transferredAmount;

  const TransferToInstallmentResult({
    required this.isSuccess,
    required this.transferredAmount,
  });
}