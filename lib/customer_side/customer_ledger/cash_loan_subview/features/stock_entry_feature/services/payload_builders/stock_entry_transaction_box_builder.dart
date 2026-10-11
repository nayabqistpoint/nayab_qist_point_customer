class StockEntryTransactionBoxBuilder {
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
    final String nowIso = now.toIso8601String();
    final int effectiveAmount = isPromotionalOnOrder ? 0 : purchasePrice;

    return {
      'docId': 'TX-STOCK-${now.millisecondsSinceEpoch}',
      'txId': 'TX-STOCK-${now.millisecondsSinceEpoch}',
      'customerPhone': customerPhone,
      'txType': 'STOCK',
      'title': isPromotionalOnOrder ? 'پروموشنل شوکیس لسٹنگ (آرڈر پر)' : 'سپلائر موبائل اسٹاک انٹری (لاٹ)',
      'amount': effectiveAmount,
      'type': 'CREDIT',
      'txColor': 'GREEN', // 🟢 آسان اور واضح کلر
      'status': 'PENDING',
      'date': '${now.day} اکتوبر ${now.year}',
      'createdAt': nowIso,
      'updatedAt': nowIso,
      'isSynced': false, // ☁️ سنک ٹریگر
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