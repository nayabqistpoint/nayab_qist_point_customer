class StockEntryTransactionBoxBuilder {
  /// transactionBox کے لیے نیا ٹرانزیکشن ریکارڈ بنانا
  static Map<String, dynamic> build({
    required String customerPhone,
    required String model,
    required String ramRom,
    required String conditionRating,
    required String warranty,
    required int purchasePrice,
    required bool isPromotionalOnOrder,
    required List<String> images,
  }) {
    final now = DateTime.now();
    final int effectiveAmount = isPromotionalOnOrder ? 0 : purchasePrice;

    return {
      'txId': 'TX-STOCK-${now.millisecondsSinceEpoch}',
      'customerPhone': customerPhone,
      'txType': 'STOCK',
      'title': isPromotionalOnOrder ? 'پروموشنل شوکیس لسٹنگ (آرڈر پر)' : 'سپلائر موبائل اسٹاک انٹری (لاٹ)',
      'amount': effectiveAmount,
      'type': 'CREDIT',
      'date': '${now.day} اکتوبر ${now.year}',
      'timestamp': now.toIso8601String(),
      'hasPhoto': images.isNotEmpty,
      'hasAudio': false,
      'stockItems': [
        {
          'model': model,
          'specs': ramRom,
          'condition': conditionRating,
          'warranty': warranty,
          'cost': purchasePrice,
        }
      ],
    };
  }
}