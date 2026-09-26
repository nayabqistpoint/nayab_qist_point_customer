class LedgerMathService {
  /// رقم کو کوما کے ساتھ فارمیٹ کرنے کے لیے (مثلاً: 7,100)
  static String formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// فیصد نکالنے کے لیے (0 سے 100 تک)
  static int calculatePercentage(int paid, int total) {
    if (total <= 0) return 0;
    final double ratio = (paid / total).clamp(0.0, 1.0);
    return (ratio * 100).toInt();
  }

  /// قسط کی اصل حالت (Status) معلوم کرنے کا کاروباری فارمولا
  static String resolveInstallmentStatus({
    required int dueAmount,
    required int paidAmount,
    required int remainingAmount,
    required String? dueDateStr,
  }) {
    // 1. اگر مکمل ادا ہو چکی ہو
    if (remainingAmount <= 0 || (dueAmount > 0 && paidAmount >= dueAmount)) {
      return 'PAID';
    }

    // 2. تاریخ کا جائزہ لینا
    DateTime? dueDate;
    if (dueDateStr != null && dueDateStr.isNotEmpty) {
      dueDate = DateTime.tryParse(dueDateStr);
    }

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    if (dueDate != null) {
      final DateTime dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);

      // اگر مقررہ تاریخ گزر چکی ہے یا آج ہی ہے اور رقم باقی ہے
      if (today.isAfter(dueDay) || today.isAtSameMomentAs(dueDay)) {
        return 'DUE'; // واجب الادا / شارٹ قسط
      }
    }

    // 3. اگر تاریخ ابھی مستقبل میں ہے لیکن کچھ رقم دی ہوئی ہے
    if (paidAmount > 0) {
      return 'PARTIAL'; // جزوی ادائیگی
    }

    // 4. آئندہ آنے والی قسط
    return 'UPCOMING';
  }

  /// ایک آرڈر کی تمام اقساط سے بقایا رقم کا ٹوٹل
  static int calculateOrderRemaining(Map<dynamic, dynamic> order) {
    final installments = (order['installments'] as List?) ?? [];
    int remaining = 0;
    for (final inst in installments) {
      if (inst is Map) {
        final rem = (inst['remainingAmount'] as num?)?.toInt() ?? 0;
        remaining += rem;
      }
    }
    return remaining;
  }
}