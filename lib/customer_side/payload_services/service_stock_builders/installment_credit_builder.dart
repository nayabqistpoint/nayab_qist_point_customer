class InstallmentCreditBuilder {
  static Map<String, dynamic> buildInstallmentAdjustment({
    required dynamic rawOrder,
    required int billAmount,
    required String note,
  }) {
    final order = Map<String, dynamic>.from(rawOrder as Map);
    final installments = List<Map<String, dynamic>>.from(
      (order['installments'] as List).map((x) => Map<String, dynamic>.from(x as Map)),
    );

    int remainingCredit = billAmount;

    // واٹر فال ترتیب کے مطابق پہلی نامکمل قسط کو تلاش کر کے اپڈیٹ کرنا
    for (var inst in installments) {
      if (remainingCredit <= 0) break;

      final dueAmount = (inst['dueAmount'] as num?)?.toInt() ?? 0;
      final currentPaid = (inst['paidAmount'] as num?)?.toInt() ?? 0;
      final unpaid = dueAmount - currentPaid;

      if (unpaid > 0) {
        if (remainingCredit >= unpaid) {
          inst['paidAmount'] = dueAmount;
          inst['status'] = 'PENDING';
          remainingCredit -= unpaid;
        } else {
          inst['paidAmount'] = currentPaid + remainingCredit;
          inst['status'] = 'PENDING';
          remainingCredit = 0;
        }
      }
    }

    order['installments'] = installments;
    order['status'] = 'PENDING';
    order['isSynced'] = false;
    order['lastUpdated'] = DateTime.now().toIso8601String();
    order['lastAdjustmentNote'] = note;

    return order;
  }
}