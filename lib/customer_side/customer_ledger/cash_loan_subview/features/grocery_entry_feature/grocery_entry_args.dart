class GroceryEntryArgs {
  final String customerPhone;

  const GroceryEntryArgs({required this.customerPhone});
}

class GroceryEntryResult {
  final bool isSuccess;
  final int grandTotal;

  const GroceryEntryResult({
    required this.isSuccess,
    required this.grandTotal,
  });
}