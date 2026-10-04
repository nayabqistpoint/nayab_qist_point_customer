class StockBoxPayloadBuilder {
  static Map<String, dynamic> buildStockDocument({
    required Map<String, dynamic> rawItem,
    required String activePhone,
    required String supplierName,
    required String note,
  }) {
    return {
      'itemId': rawItem['itemId'],
      'itemName': rawItem['itemName'],
      'supplier': supplierName,
      'customerPhone': activePhone,
      'color': rawItem['color'],
      'conditionType': rawItem['conditionType'],
      'conditionRating': rawItem['conditionRating'],
      'ramRom': rawItem['ramRom'],
      'imeiNo': rawItem['imeiNo'],
      'purchasePrice': rawItem['purchasePrice'],
      'salePrice': rawItem['salePrice'],
      'quantity': 1,
      'warranty': rawItem['warranty'],
      'images': rawItem['images'] ?? '',
      'status': rawItem['status'],
      'note': note,
      'isSynced': false, // 🎯 سنک ٹرگر کے لیے ضروری فیلڈ
      'syncStatus': 'PENDING',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}