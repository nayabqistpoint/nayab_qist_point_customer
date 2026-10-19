import 'package:flutter/material.dart';

class SplitSourceItem {
  String source;
  int amount;

  SplitSourceItem({required this.source, required this.amount});

  Map<String, dynamic> toMap() => {'source': source, 'amount': amount};
}

class PaymentRebalanceEngine {
  PaymentRebalanceEngine._();

  static int calculateNetPayableAfterDiscount({
    required int totalTarget,
    required int discountAmount,
  }) {
    final net = totalTarget - discountAmount;
    return net > 0 ? net : 0;
  }

  static void autoAdjustPrimarySource({
    required List<SplitSourceItem> splits,
    required List<TextEditingController> controllers,
    required int totalTarget,
    required int discountAmount,
  }) {
    if (splits.isEmpty) return;

    final int netRequired = calculateNetPayableAfterDiscount(
      totalTarget: totalTarget,
      discountAmount: discountAmount,
    );

    if (splits.length == 1) {
      splits[0].amount = netRequired;
    } else {
      int otherSourcesSum = 0;
      for (int i = 1; i < splits.length; i++) {
        otherSourcesSum += splits[i].amount;
      }
      final int autoPrimary = netRequired - otherSourcesSum;
      splits[0].amount = autoPrimary > 0 ? autoPrimary : 0;
    }

    if (controllers.isNotEmpty && splits.isNotEmpty) {
      final currentTxt = controllers[0].text;
      final newTxt = splits[0].amount.toString();
      if (currentTxt != newTxt) {
        controllers[0].text = newTxt;
      }
    }
  }

  static int calculateTotalSplits(List<SplitSourceItem> splits) {
    return splits.fold(0, (sum, item) => sum + item.amount);
  }

  static int calculateDiscrepancy({
    required int totalTarget,
    required int splitsTotal,
    required int discountAmount,
  }) {
    return splitsTotal -
        calculateNetPayableAfterDiscount(
          totalTarget: totalTarget,
          discountAmount: discountAmount,
        );
  }

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