import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';
import '../hive_services/hive_box_manager.dart';
import '../universal_payments/universal_payment_page.dart';
import '../service_stock/service_stock_entry_page.dart';
import 'services/ledger_services/installment_ledger_service.dart';
import 'services/ledger_services/ledger_math_service.dart';

class CustomerLedgerController extends ChangeNotifier {
  String customerPhone;

  int selectedTabIndex = 0;
  int selectedProductIndex = 0;
  bool isLoading = true;

  List<Map<String, dynamic>> customerProducts = [];

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
      'target': 'قسط کھاتہ',
      'hasAudio': true,
      'hasPhoto': true,
      'date': '09 ستمبر 2026',
    },
  ];

  CustomerLedgerController({this.customerPhone = ''}) {
    _initialize();
  }

  Future<void> _initialize() async {
    // ۱. اگر پیرنٹ سے فون نہ ملا ہو تو HiveBoxManager کے settingsBox سے سیشن فون حاصل کریں
    if (customerPhone.trim().isEmpty) {
      try {
        final settingsBox = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
        final phone = settingsBox.get('activePhone') ?? settingsBox.get('remembered_phone');
        if (phone != null && phone.toString().trim().isNotEmpty) {
          customerPhone = phone.toString().trim();
        }
      } catch (_) {}
    }

    // ۲. انسٹالمنٹ باکس اوپن یقینی بنائیں
    await InstallmentLedgerService.ensureBoxOpen();

    // ۳. لسنر اٹیچ کریں
    InstallmentLedgerService.boxListenable?.addListener(_onHiveBoxChanged);

    // ۴. ڈیٹا لوڈ کریں
    await loadCustomerData();
    isLoading = false;
    notifyListeners();
  }

  void _onHiveBoxChanged() {
    loadCustomerData();
  }

  @override
  void dispose() {
    InstallmentLedgerService.boxListenable?.removeListener(_onHiveBoxChanged);
    super.dispose();
  }

  Future<void> loadCustomerData() async {
    customerProducts = await InstallmentLedgerService.getCustomerInstallmentOrders(customerPhone);

    if (selectedProductIndex >= customerProducts.length) {
      selectedProductIndex = 0;
    }
    notifyListeners();
  }

  int get totalInstallmentDue {
    return customerProducts.fold(0, (sum, p) => sum + ((p['remaining'] as int?) ?? 0));
  }

  int get approvedServiceCredit => serviceTransactions
      .where((t) => t['syncStatus'] == 'ADMIN_APPROVED')
      .fold(0, (sum, t) => sum + (t['totalAmount'] as int));

  int get grandNetTotal => (totalInstallmentDue + cashLoanBalance) - approvedServiceCredit;

  String formatAmount(int amount) => LedgerMathService.formatAmount(amount);

  void setTabIndex(int index) {
    selectedTabIndex = index;
    notifyListeners();
  }

  void setProductIndex(int index) {
    selectedProductIndex = index;
    notifyListeners();
  }

  void toggleTransactionExpand(Map<String, dynamic> item) {
    item['isExpanded'] = !(item['isExpanded'] ?? false);
    notifyListeners();
  }

  void openPurchasePage(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.purchaseMarket,
      arguments: {'customerPhone': customerPhone},
    );
  }

  Future<void> handleInstallmentPayment(BuildContext context, Map<String, dynamic> schedItem) async {
    final remaining = (schedItem['remainingAmount'] as int?) ??
        ((schedItem['amount'] as int) - ((schedItem['paidAmount'] as int?) ?? 0));

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UniversalPaymentPage(
          title: 'قسط نمبر ${schedItem['no']} کی ادائیگی',
          baseAmount: remaining,
          isInstallment: true,
        ),
      ),
    );

    if (result != null) {
      await loadCustomerData();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('قسط وصولی جمع ہو گئی: Rs. ${formatAmount(result['paid'] ?? remaining)}'),
            backgroundColor: const Color(0xFF059669),
          ),
        );
      }
    }
  }

  Future<void> handleCashLoanRepayment(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UniversalPaymentPage(
          title: 'نقد دستی ادھار کی واپسی',
          baseAmount: cashLoanBalance,
          isInstallment: false,
        ),
      ),
    );

    if (result != null) {
      final int paid = result['paid'] as int;
      final int discount = (result['discount'] as int?) ?? 0;
      cashLoanBalance -= (paid + discount);
      cashLoanEntries.insert(0, {
        'title': 'دستی قرض واپسی ادا کی',
        'date': 'آج',
        'amount': paid,
        'type': 'CREDIT',
      });
      notifyListeners();
    }
  }

  Future<void> handleNewServiceTransaction(BuildContext context) async {
    final newTransaction = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceStockEntryPage(
          targetAccounts: [
            ...customerProducts.map((p) => 'قسط کھاتہ: ${p['name']}'),
            'نقد دستی ادھار کھاتہ',
            'نیا / آزاد کسٹمر کریڈٹ کھاتہ',
          ],
        ),
      ),
    );

    if (newTransaction != null) {
      serviceTransactions.insert(0, newTransaction);
      notifyListeners();
    }
  }
}