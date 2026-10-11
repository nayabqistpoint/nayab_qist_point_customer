class CashLoanArgs {
  final String customerPhone;
  final String Function(int) formatAmount;

  const CashLoanArgs({
    required this.customerPhone,
    required this.formatAmount,
  });
}