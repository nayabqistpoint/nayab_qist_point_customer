class StockBoxBuilder {
  static List<Map<String, dynamic>> buildStockItems({
    required List<Map<String, dynamic>> stockList,
    required String supplierPhone,
  }) {
    final now = DateTime.now().toIso8601String();
    return stockList.map((item) {
      return {
        ...item,
        'supplierPhone': supplierPhone,
        'createdAt': now,
        'isSynced': false,
      };
    }).toList();
  }
}