class LedgerCalculationService {
  LedgerCalculationService._();

  static String formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  static Map<String, dynamic> parseInstallmentsSummary(List<Map<String, dynamic>> rawOrders) {
    int totalDue = 0;
    int overdueCount = 0;
    int overdueAmount = 0;
    String firstMobileTitle = 'کوئی فعال پلان نہیں';
    String firstPlanSubtitle = '0 اقساط';

    if (rawOrders.isNotEmpty) {
      final first = rawOrders.first;
      firstMobileTitle = first['itemName']?.toString() ?? 'موبائل فون';
      final totalMonths = first['totalMonths']?.toString() ?? '';
      firstPlanSubtitle = totalMonths.isNotEmpty ? '$totalMonths ماہ پلان' : 'اقساط پلان';

      for (final order in rawOrders) {
        final installments = (order['installments'] as List?) ?? [];
        for (final rawInst in installments) {
          if (rawInst is Map) {
            final due = (rawInst['dueAmount'] as num?)?.toInt() ?? 0;
            final vStatus = (rawInst['verificationStatus'] ?? '').toString().toUpperCase();
            final bool isApproved = vStatus == 'APPROVED' || vStatus == 'VERIFIED';
            final paid = isApproved ? ((rawInst['paidAmount'] as num?)?.toInt() ?? 0) : 0;
            final remaining = (due - paid).clamp(0, due);

            totalDue += remaining;

            final status = (rawInst['status'] ?? '').toString().toUpperCase();
            if (status == 'DUE' && remaining > 0) {
              overdueCount++;
              overdueAmount += remaining;
            }
          }
        }
      }
    }

    return {
      'totalDue': totalDue,
      'overdueCount': overdueCount,
      'overdueAmount': overdueAmount,
      'mobileTitle': firstMobileTitle,
      'planSubtitle': firstPlanSubtitle,
    };
  }

  static int calculateGrandNetTotal({
    required int installmentDue,
    required int cashLoanBalance,
  }) {
    return installmentDue + cashLoanBalance;
  }
}