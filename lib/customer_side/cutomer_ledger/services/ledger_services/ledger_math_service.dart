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

  static String resolveInstallmentStatus({
    required int dueAmount,
    required int paidAmount,
    required int remainingAmount,
    required String? dueDateStr,
    int installmentNo = 2,
  }) {
    if (remainingAmount <= 0 || (dueAmount > 0 && paidAmount >= dueAmount)) {
      return 'PAID';
    }
    if (LedgerDateService.isDueOrPassed(dueDateStr, installmentNo: installmentNo)) {
      return 'DUE';
    }
    if (paidAmount > 0) {
      return 'PARTIAL';
    }
    return 'UPCOMING';
  }

  static Map<String, dynamic> calculateOverdueSummary(List<Map<String, dynamic>> schedule) {
    int count = 0;
    int amount = 0;
    for (final item in schedule) {
      if (item['status'] == 'DUE' && ((item['remainingAmount'] as int?) ?? 0) > 0) {
        count++;
        amount += (item['remainingAmount'] as int);
      }
    }
    return {'count': count, 'amount': amount, 'hasOverdue': count > 0};
  }

  static int calculateOrderRemaining(Map<dynamic, dynamic> order) {
    final installments = (order['installments'] as List?) ?? [];
    return installments.fold<int>(0, (sum, inst) {
      return sum + ((inst is Map ? inst['remainingAmount'] as num? : 0)?.toInt() ?? 0);
    });
  }
}