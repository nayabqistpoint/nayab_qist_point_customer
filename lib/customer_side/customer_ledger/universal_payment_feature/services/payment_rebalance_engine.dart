// lib/customer_side/universal_payments/universal_payment_services/payment_rebalance_engine.dart

class SplitSourceItem {
  String source;
  int amount;

  SplitSourceItem({required this.source, required this.amount});

  Map<String, dynamic> toMap() => {'source': source, 'amount': amount};
}

class PaymentRebalanceEngine {
  /// مطلوبہ وصولی رقم میں سے ڈسکاؤنٹ نکال کر حقیقی نقد/بینک رقم معلوم کرنا
  static int calculateNetPayableAfterDiscount({
    required int totalTarget,
    required int discountAmount,
  }) {
    final net = totalTarget - discountAmount;
    return net > 0 ? net : 0;
  }

  /// جب کل رقم یا رعایت بدلے تو پہلے سورس (کیش) کو خودکار طور پر ری بیلنس کرنا
  static void autoAdjustPrimarySource({
    required List<SplitSourceItem> splits,
    required int totalTarget,
    required int discountAmount,
  }) {
    if (splits.isEmpty) return;

    final int netRequired = calculateNetPayableAfterDiscount(
      totalTarget: totalTarget,
      discountAmount: discountAmount,
    );

    // اگر صرف ایک ہی سورس موجود ہے تو پوری بقیہ رقم اس میں منتقل کر دیں
    if (splits.length == 1) {
      splits[0].amount = netRequired;
      return;
    }

    // اگر ایک سے زیادہ سورسز ہیں تو باقی تمام سورسز کی رقم جمع کریں
    int otherSourcesSum = 0;
    for (int i = 1; i < splits.length; i++) {
      otherSourcesSum += splits[i].amount;
    }

    // پہلے سورس (کیش) کو آٹو بیلنس کریں
    final int autoPrimary = netRequired - otherSourcesSum;
    splits[0].amount = autoPrimary > 0 ? autoPrimary : 0;
  }

  /// تمام سورسز کا مجموعہ معلوم کرنا
  static int calculateTotalSplits(List<SplitSourceItem> splits) {
    return splits.fold(0, (sum, item) => sum + item.amount);
  }

  /// فرق معلوم کرنا: (سورسز کا مجموعہ + رعایت) بمقابلہ (مطلوبہ کل وصولی)
  static int calculateDiscrepancy({
    required int totalTarget,
    required int splitsTotal,
    required int discountAmount,
  }) {
    return splitsTotal - calculateNetPayableAfterDiscount(
      totalTarget: totalTarget,
      discountAmount: discountAmount,
    );
  }

  /// مکمل حساب برابر ہونے کی سخت ویلیڈیشن چیک
  static bool verifyReconciliation({
    required int totalTarget,
    required int splitsTotal,
    required int discountAmount,
  }) {
    if (totalTarget <= 0) return false;
    final int netRequired = calculateNetPayableAfterDiscount(
      totalTarget: totalTarget,
      discountAmount: discountAmount,
    );
    return splitsTotal == netRequired;
  }
}