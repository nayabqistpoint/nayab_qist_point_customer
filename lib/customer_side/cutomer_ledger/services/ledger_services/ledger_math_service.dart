import 'ledger_date_service.dart';

class LedgerMathService {
  static String formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  static int calculatePercentage(int paid, int total) {
    if (total <= 0) return 0;
    return ((paid / total).clamp(0.0, 1.0) * 100).toInt();
  }

  /// قسط کا اسٹیٹس معلوم کرنا (صرف منظور شدہ ادا کے مطابق)
  static String resolveInstallmentStatus({
    required int dueAmount,
    required int approvedPaidAmount,
    required int remainingAmount,
    required String? dueDateStr,
    int installmentNo = 2,
  }) {
    if (remainingAmount <= 0 || (dueAmount > 0 && approvedPaidAmount >= dueAmount)) {
      return 'PAID';
    }
    if (LedgerDateService.isDueOrPassed(dueDateStr, installmentNo: installmentNo)) {
      return 'DUE';
    }
    if (approvedPaidAmount > 0) {
      return 'PARTIAL';
    }
    return 'UPCOMING';
  }

  /// شارٹ اور اوور ڈیو کا خلاصہ
  static Map<String, dynamic> calculateOverdueSummary(List<Map<String, dynamic>> schedule) {
    int count = 0;
    int amount = 0;
    for (final item in schedule) {
      final String status = item['status']?.toString() ?? '';
      final int rem = (item['remainingAmount'] as int?) ?? 0;
      if (status == 'DUE' && rem > 0) {
        count++;
        amount += rem;
      }
    }
    return {'count': count, 'amount': amount, 'hasOverdue': count > 0};
  }
}