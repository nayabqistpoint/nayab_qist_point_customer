class TransactionHistoryService {
  TransactionHistoryService._();

  static List<Map<String, dynamic>> filterAndSortByCustomer({
    required List<Map<String, dynamic>> rawTransactions,
    required String customerPhone,
  }) {
    final cleanPhone = customerPhone.replaceAll(RegExp(r'\s+'), '').trim();
    final List<Map<String, dynamic>> matched = [];

    for (final entry in rawTransactions) {
      final orderPhone = (entry['customerPhone'] ?? '')
          .toString()
          .replaceAll(RegExp(r'\s+'), '')
          .trim();

      final bool isMatch = cleanPhone.isNotEmpty &&
          (orderPhone == cleanPhone ||
              (cleanPhone.length >= 10 &&
                  orderPhone.endsWith(cleanPhone.substring(cleanPhone.length - 10))));

      if (isMatch) {
        matched.add(entry);
      }
    }

    matched.sort((a, b) {
      final String dateA = (a['date'] ?? a['paymentDate'] ?? a['createdAt'] ?? '').toString();
      final String dateB = (b['date'] ?? b['paymentDate'] ?? b['createdAt'] ?? '').toString();
      return dateB.compareTo(dateA);
    });

    return matched;
  }

  static List<Map<String, dynamic>> applyFilterTab({
    required List<Map<String, dynamic>> transactions,
    required int filterIndex,
  }) {
    if (filterIndex == 0) return transactions;

    if (filterIndex == 1) {
      return transactions.where((t) {
        final String type = (t['type'] ?? t['txType'] ?? '').toString().toUpperCase();
        final String orderDocId = (t['orderDocId'] ?? '').toString();
        return type.contains('INSTALLMENT') || orderDocId != 'CASH_LOAN_ACCOUNT';
      }).toList();
    }

    if (filterIndex == 2) {
      return transactions.where((t) {
        final String type = (t['type'] ?? t['txType'] ?? '').toString().toUpperCase();
        final String orderDocId = (t['orderDocId'] ?? '').toString();
        return type.contains('CASH') ||
            type.contains('GROCERY') ||
            type.contains('STOCK') ||
            orderDocId == 'CASH_LOAN_ACCOUNT';
      }).toList();
    }

    if (filterIndex == 3) {
      return transactions.where((t) {
        final String vStatus = (t['verificationStatus'] ?? 'UNDER_REVIEW').toString().toUpperCase();
        return vStatus != 'APPROVED' && vStatus != 'VERIFIED';
      }).toList();
    }

    return transactions;
  }

  static String formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}