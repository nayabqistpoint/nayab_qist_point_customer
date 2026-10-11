// lib/customer_side/payload_services/installment_payload_builders/installment_order_update_builder.dart

class InstallmentOrderUpdateBuilder {
  /// قسطوں کی واٹر فال تقسیم کا مکمل حساب کر کے اپڈیٹ شدہ آرڈر لسٹ اور لاگ واپس کرتا ہے
  static Map<String, dynamic> buildUpdatedOrder({
    required Map<dynamic, dynamic> rawOrder,
    required int totalCollectedAmount,
  }) {
    final Map<String, dynamic> updatedOrder = Map<String, dynamic>.from(rawOrder);
    final List originalInstallments = (rawOrder['installments'] as List?) ?? [];
    final List<Map<String, dynamic>> updatedInstallments = [];
    final List<String> allocationLogs = [];

    int pool = totalCollectedAmount;

    for (int i = 0; i < originalInstallments.length; i++) {
      final inst = Map<String, dynamic>.from(originalInstallments[i] as Map);
      final int dueAmount = (inst['dueAmount'] as num?)?.toInt() ?? 0;
      final int previouslyPaid = (inst['paidAmount'] as num?)?.toInt() ?? 0;
      final int currentRemaining = (inst['remainingAmount'] as num?)?.toInt() ?? (dueAmount - previouslyPaid);
      final int instNo = (inst['installmentNo'] as num?)?.toInt() ?? (i + 1);

      // اگر یہ قسط پہلے ہی مکمل ہو چکی ہے
      if (currentRemaining <= 0) {
        updatedInstallments.add(inst);
        continue;
      }

      // اگر پیسے ابھی باقی ہیں تو اس قسط میں ڈالیں
      if (pool > 0) {
        if (pool >= currentRemaining) {
          // قسط پوری ادا ہو گئی
          final int allocated = currentRemaining;
          final int newPaid = previouslyPaid + allocated;
          pool -= allocated;

          inst['paidAmount'] = newPaid;
          inst['remainingAmount'] = 0;
          inst['paymentPercentage'] = 100;
          inst['status'] = 'PAID';
          inst['verificationStatus'] = 'UNDER_REVIEW';

          allocationLogs.add('قسط نمبر $instNo: مکمل ادا (Rs. $allocated)');
        } else {
          // قسط جزوی ادا ہوئی
          final int allocated = pool;
          final int newPaid = previouslyPaid + allocated;
          final int newRemaining = currentRemaining - allocated;
          final int percent = dueAmount > 0 ? ((newPaid / dueAmount) * 100).toInt() : 0;
          pool = 0;

          inst['paidAmount'] = newPaid;
          inst['remainingAmount'] = newRemaining;
          inst['paymentPercentage'] = percent;
          inst['status'] = 'PARTIAL';
          inst['verificationStatus'] = 'UNDER_REVIEW';

          allocationLogs.add('قسط نمبر $instNo: جزوی وصولی (Rs. $allocated، بقایا Rs. $newRemaining)');
        }
      }

      updatedInstallments.add(inst);
    }

    updatedOrder['installments'] = updatedInstallments;
    updatedOrder['isSynced'] = false;
    updatedOrder['updatedAt'] = DateTime.now().toIso8601String();

    return {
      'orderPayload': updatedOrder,
      'allocationLogs': allocationLogs,
      'unallocatedSurplus': pool, // اگر تمام قسطیں ختم ہونے کے بعد بھی رقم بچ جائے
    };
  }
}