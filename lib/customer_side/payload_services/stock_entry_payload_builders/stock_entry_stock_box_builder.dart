class StockEntryStockBoxBuilder {
  /// stockBox کے لیے نیا منفرد ڈاکومنٹ بنانا
  static Map<String, dynamic> build({
    required String model,
    required String ramRom,
    required String color,
    required String conditionType,
    required String conditionRating,
    required String imeiNo,
    required String warranty,
    required int purchasePrice,
    required double salePrice,
    required bool isPromotionalOnOrder,
    required List<String> images,
    required String customerPhone,
  }) {
    final now = DateTime.now();
    final String itemId = 'STK-${now.millisecondsSinceEpoch.toString().substring(7)}';

    return {
      'itemId': itemId,
      'itemName': model,
      'ramRom': ramRom,
      'color': color,
      'conditionType': conditionType,
      'conditionRating': conditionRating,
      'imeiNo': imeiNo,
      'warranty': warranty,
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'quantity': 1,
      'status': isPromotionalOnOrder ? 'available_on_order' : 'available',
      'customerPhone': customerPhone,
      'supplier': 'zetoon',
      'images': images.join(','),
      'createdAt': now.toIso8601String(),
    };
  }
}