class CustomerLedgerController {
  int selectedTabIndex = 0;
  int selectedProductIndex = 0;

  final List<Map<String, dynamic>> customerProducts = [
    {
      'id': 'P-101',
      'name': 'Infinix Note 40 Pro',
      'plan': '10 ماہ پلان (35% منافع)',
      'total': 75600,
      'paid': 22680,
      'monthlyInstallment': 7560,
      'schedule': [
        {'no': 1, 'date': '05 جولائی 2026', 'amount': 7560, 'paidAmount': 7560, 'status': 'PAID'},
        {'no': 2, 'date': '05 اگست 2026', 'amount': 7560, 'paidAmount': 7560, 'status': 'PAID'},
        {'no': 3, 'date': '05 ستمبر 2026', 'amount': 7560, 'paidAmount': 7560, 'status': 'PAID'},
        {'no': 4, 'date': '05 اکتوبر 2026', 'amount': 7560, 'paidAmount': 3500, 'status': 'DUE'},
        {'no': 5, 'date': '05 نومبر 2026', 'amount': 7560, 'paidAmount': 0, 'status': 'UPCOMING'},
        {'no': 6, 'date': '05 دسمبر 2026', 'amount': 7560, 'paidAmount': 0, 'status': 'UPCOMING'},
      ],
    },
    {
      'id': 'P-102',
      'name': 'Vivo Y21',
      'plan': '8 ماہ پلان (25% منافع)',
      'total': 47500,
      'paid': 15936,
      'monthlyInstallment': 5312,
      'schedule': [
        {'no': 1, 'date': '05 جولائی 2026', 'amount': 5312, 'paidAmount': 5312, 'status': 'PAID'},
        {'no': 2, 'date': '05 اگست 2026', 'amount': 5312, 'paidAmount': 5312, 'status': 'PAID'},
        {'no': 3, 'date': '05 ستمبر 2026', 'amount': 5312, 'paidAmount': 5312, 'status': 'PAID'},
        {'no': 4, 'date': '05 اکتوبر 2026', 'amount': 5312, 'paidAmount': 0, 'status': 'DUE'},
      ],
    },
  ];

  int cashLoanBalance = 50000;
  final List<Map<String, dynamic>> cashLoanEntries = [
    {'title': 'دکان سے نقد دستی کیش لیا', 'date': '10 اگست 2026', 'amount': 50000, 'type': 'DEBIT'},
  ];

  final List<Map<String, dynamic>> serviceTransactions = [
    {
      'title': 'ماہانہ کریانہ راشن بل',
      'nature': 'EXPENSE',
      'natureTitle': 'دکان و راشن خرچہ',
      'isExpanded': false,
      'syncStatus': 'ADMIN_APPROVED',
      'items': [
        {'name': 'چینی (10 کلو)', 'amount': 1500},
        {'name': 'گھی کا ڈبہ (5 لیٹر)', 'amount': 2850},
      ],
      'totalAmount': 4350,
      'target': 'Infinix قسط کھاتہ',
      'hasAudio': true,
      'hasPhoto': true,
      'date': '09 ستمبر 2026',
    },
  ];

  int get totalInstallmentDue => customerProducts.fold(0, (sum, p) => sum + ((p['total'] as int) - (p['paid'] as int)));

  int get approvedServiceCredit => serviceTransactions
      .where((t) => t['syncStatus'] == 'ADMIN_APPROVED')
      .fold(0, (sum, t) => sum + (t['totalAmount'] as int));

  int get grandNetTotal => (totalInstallmentDue + cashLoanBalance) - approvedServiceCredit;

  String formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}