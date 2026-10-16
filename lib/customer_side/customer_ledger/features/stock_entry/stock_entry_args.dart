class StockEntryArgs {
  final String customerPhone;

  const StockEntryArgs({required this.customerPhone});
}

class StockEntryResult {
  final bool isSuccess;
  final String itemId;

  const StockEntryResult({
    required this.isSuccess,
    required this.itemId,
  });
}