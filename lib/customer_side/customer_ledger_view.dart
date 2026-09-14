import 'package:flutter/material.dart';
import 'customer_ledger_controller.dart';
import 'universal_payment_page.dart';
import 'service_stock_entry_page.dart';
import 'customer_ledger_components_ui/ledger_app_bar_ui.dart';
import 'customer_ledger_components_ui/wallet_master_card_ui.dart';
import 'customer_ledger_components_ui/category_tabs_ui.dart';
import 'customer_ledger_components_ui/mobile_selector_dropdown_ui.dart';
import 'customer_ledger_components_ui/installment_table_header_ui.dart';
import 'customer_ledger_components_ui/installment_table_row_ui.dart';
import 'customer_ledger_components_ui/cash_loan_section_ui.dart';
import 'customer_ledger_components_ui/service_transactions_section_ui.dart';

class CustomerLedgerView extends StatefulWidget {
  const CustomerLedgerView({super.key});

  @override
  State<CustomerLedgerView> createState() => _CustomerLedgerViewState();
}

class _CustomerLedgerViewState extends State<CustomerLedgerView> {
  final CustomerLedgerController _controller = CustomerLedgerController();

  void _openPurchasePackageModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined, color: Color(0xFF1E293B), size: 22),
                    SizedBox(width: 8),
                    Text(
                      'نیا موبائل یا قسط پلان منتخب کریں',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'نایاب قسط پوائنٹ کے 28 تصدیق شدہ اقساطی پلانز میں سے آرڈر بھیجیں:',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                ),
                const Divider(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.phone_android_rounded, color: Color(0xFF2563EB)),
                  ),
                  title: const Text(
                    'Redmi Note 13 (8/256)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('10 ماہ کا پلان | ایڈوانس: Rs. 15,000'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('نئے موبائل کا پرچیز آرڈر ایڈمن کو چلا گیا (پینڈنگ)!'),
                          backgroundColor: Color(0xFF16A34A),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('آرڈر بھیجیں', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int net = _controller.grandNetTotal;
    final bool isDebtor = net >= 0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: LedgerAppBarUi(onPurchasePressed: _openPurchasePackageModal),
        body: SingleChildScrollView(
          // 👈 ہمیشہ سکرول اور لچکدار موبائل باؤنس
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              WalletMasterCardUi(
                net: net,
                isDebtor: isDebtor,
                totalInstallmentDue: _controller.totalInstallmentDue,
                cashLoanBalance: _controller.cashLoanBalance,
                approvedServiceCredit: _controller.approvedServiceCredit,
                formatAmount: _controller.formatAmount,
              ),
              const SizedBox(height: 12),
              CategoryTabsUi(
                selectedTabIndex: _controller.selectedTabIndex,
                totalInstallmentDue: _controller.totalInstallmentDue,
                cashLoanBalance: _controller.cashLoanBalance,
                approvedServiceCredit: _controller.approvedServiceCredit,
                formatAmount: _controller.formatAmount,
                onTabSelected: (index) => setState(() => _controller.selectedTabIndex = index),
              ),
              const SizedBox(height: 12),
              if (_controller.selectedTabIndex == 0) ...[
                MobileSelectorDropdownUi(
                  products: _controller.customerProducts,
                  selectedIndex: _controller.selectedProductIndex,
                  onChanged: (v) => setState(() => _controller.selectedProductIndex = v!),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      InstallmentTableHeaderUi(
                        planName: _controller.customerProducts[_controller.selectedProductIndex]['plan'],
                        monthlyInstallment: _controller.formatAmount(
                          _controller.customerProducts[_controller.selectedProductIndex]['monthlyInstallment'],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      Table(
                        border: TableBorder.symmetric(
                          inside: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
                        ),
                        columnWidths: const {
                          0: FlexColumnWidth(0.6),
                          1: FlexColumnWidth(1.2),
                          2: FlexColumnWidth(2.4),
                        },
                        children: [
                          const TableRow(
                            decoration: BoxDecoration(color: Color(0xFFF8FAFC)),
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 11),
                                child: Text(
                                  '#',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 11),
                                child: Text(
                                  'تاریخ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 11),
                                child: Text(
                                  'قسط کی رقم، پروگریس و ادائیگی',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                                ),
                              ),
                            ],
                          ),
                          ...((_controller.customerProducts[_controller.selectedProductIndex]['schedule'] as List).map((item) {
                            return InstallmentTableRowUi.build(
                              context: context,
                              item: item,
                              formatAmount: _controller.formatAmount,
                              onPaymentRequested: (schedItem) async {
                                final messenger = ScaffoldMessenger.of(context);
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UniversalPaymentPage(
                                      title: 'قسط نمبر ${schedItem['no']} کی ادائیگی',
                                      baseAmount: (schedItem['amount'] as int) - ((schedItem['paidAmount'] as int?) ?? 0),
                                      isInstallment: true,
                                    ),
                                  ),
                                );
                                if (!mounted) return;
                                if (result != null) {
                                  setState(() {
                                    int newlyPaid = result['paid'] as int;
                                    int totalAmt = schedItem['amount'] as int;
                                    int currentPaid = (schedItem['paidAmount'] as int?) ?? 0;
                                    int updatedPaid = currentPaid + newlyPaid;
                                    schedItem['paidAmount'] = updatedPaid;
                                    if (updatedPaid >= totalAmt) {
                                      schedItem['status'] = 'PAID';
                                    }
                                    _controller.customerProducts[_controller.selectedProductIndex]['paid'] =
                                        (_controller.customerProducts[_controller.selectedProductIndex]['paid'] as int) +
                                            (result['resolved'] as int);
                                  });
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text('قسط ادا! وصولی: Rs. ${_controller.formatAmount(result['paid'])}'),
                                      backgroundColor: const Color(0xFF059669),
                                    ),
                                  );
                                }
                              },
                            );
                          })),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              if (_controller.selectedTabIndex == 1) ...[
                CashLoanSectionUi(
                  cashLoanBalance: _controller.cashLoanBalance,
                  cashLoanEntries: _controller.cashLoanEntries,
                  formatAmount: _controller.formatAmount,
                  onRepaymentPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UniversalPaymentPage(
                          title: 'نقد دستی ادھار کی واپسی',
                          baseAmount: _controller.cashLoanBalance,
                          isInstallment: false,
                        ),
                      ),
                    );
                    if (!mounted) return;
                    if (result != null) {
                      setState(() {
                        _controller.cashLoanBalance -= ((result['paid'] as int) + (result['discount'] as int));
                        _controller.cashLoanEntries.insert(0, {
                          'title': 'دستی قرض واپسی ادا کی',
                          'date': 'آج',
                          'amount': result['paid'],
                          'type': 'CREDIT',
                        });
                      });
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text('قرض واپسی جمع! رقم: Rs. ${_controller.formatAmount(result['paid'])}'),
                          backgroundColor: const Color(0xFF059669),
                        ),
                      );
                    }
                  },
                ),
              ],
              if (_controller.selectedTabIndex == 2) ...[
                ServiceTransactionsSectionUi(
                  serviceTransactions: _controller.serviceTransactions,
                  formatAmount: _controller.formatAmount,
                  onNewServicePressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final newTransaction = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceStockEntryPage(
                          targetAccounts: [
                            ..._controller.customerProducts.map((p) => 'قسط کھاتہ: ${p['name']}'),
                            'نقد دستی ادھار کھاتہ',
                            'نیا / آزاد کسٹمر کریڈٹ کھاتہ',
                          ],
                        ),
                      ),
                    );
                    if (!mounted) return;
                    if (newTransaction != null) {
                      setState(() {
                        _controller.serviceTransactions.insert(0, newTransaction);
                      });
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            'Rs. ${_controller.formatAmount(newTransaction['totalAmount'])} کا بل ایڈمن منظوری کے لیے ارسال ہو گیا!',
                          ),
                          backgroundColor: const Color(0xFF059669),
                        ),
                      );
                    }
                  },
                  onToggleExpand: (item) {
                    setState(() {
                      item['isExpanded'] = !(item['isExpanded'] ?? false);
                    });
                  },
                ),
              ],

              // 👈 اضافی اسپیس تاکہ موبائل پر انگوٹھے سے نیچے تک کا پورا حصہ باآسانی اوپر کھینچا جا سکے
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}