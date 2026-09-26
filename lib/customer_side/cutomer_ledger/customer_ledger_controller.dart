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

  // نقد ادھار کی معلومات
  int cashLoanBalance = 50000;
  final List<Map<String, dynamic>> cashLoanEntries = [
    {
      'title': 'دکان سے نقد دستی کیش لیا',
      'date': '10 اگست 2026',
      'amount': 50000,
      'type': 'DEBIT',
    },
  ];

  // خدمات و راشن ٹرانزیکشنز
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
    // اگر فون نمبر پاس نہ ہوا ہو تو ایکٹو سیشن سے لینا
    if (customerPhone.trim().isEmpty) {
      try {
        final settingsBox = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
        final phone = settingsBox.get('activePhone') ?? settingsBox.get('remembered_phone');
        if (phone != null && phone.toString().trim().isNotEmpty) {
          customerPhone = phone.toString().trim();
        }
      } catch (_) {}
    }

    await InstallmentLedgerService.ensureBoxOpen();
    InstallmentLedgerService.boxListenable?.addListener(_onHiveBoxChanged);
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

  // کل اقساط کی واجب رقم
  int get totalInstallmentDue {
    return customerProducts.fold(0, (sum, p) => sum + ((p['remaining'] as int?) ?? 0));
  }

  // زیرِ جائزہ (Pending Review) بلز کی کل رقم
  int get pendingServiceCredit => serviceTransactions
      .where((t) => (t['syncStatus'] ?? '').toString().toUpperCase() != 'ADMIN_APPROVED')
      .fold(0, (sum, t) => sum + ((t['totalAmount'] as num?)?.toInt() ?? 0));

  // منظور شدہ بلز (صرف ریکارڈ کے لیے، مین کھاتے میں ڈبل کٹوتی نہیں ہوگی)
  int get approvedServiceCredit => serviceTransactions
      .where((t) => (t['syncStatus'] ?? '').toString().toUpperCase() == 'ADMIN_APPROVED')
      .fold(0, (sum, t) => sum + ((t['totalAmount'] as num?)?.toInt() ?? 0));

  // اصل کل خالص میزان (اقساط واجب + نقد قرض)
  int get grandNetTotal => totalInstallmentDue + cashLoanBalance;

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

  // قسط ادائیگی کا ہینڈلر
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

  // نقد ادھار واپسی کا ہینڈلر
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

  // نئی سروس / راشن ٹرانزیکشن کا ہینڈلر
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