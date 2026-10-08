class LedgerCalculationService {
  static int calculateTotalInstallmentDue(List<Map<String, dynamic>> products) {
    return products.fold(0, (sum, p) => sum + ((p['remaining'] as int?) ?? 0));
  }

  static int calculatePendingServiceCredit(List<Map<String, dynamic>> txs) {
    return txs
        .where((t) => (t['status'] ?? '').toString().toUpperCase() != 'APPROVED')
        .fold(0, (sum, t) => sum + ((t['totalAmount'] as num?)?.toInt() ?? 0));
  }

  static int calculateApprovedServiceCredit(List<Map<String, dynamic>> txs) {
    return txs
        .where((t) => (t['status'] ?? '').toString().toUpperCase() == 'APPROVED')
        .fold(0, (sum, t) => sum + ((t['totalAmount'] as num?)?.toInt() ?? 0));
  }

  static int calculateGrandNetTotal({
    required int installmentDue,
    required int cashLoanBalance,
    required int approvedServiceCredit,
  }) {
    final int net = (installmentDue + cashLoanBalance) - approvedServiceCredit;
    return net > 0 ? net : 0;
  }
}