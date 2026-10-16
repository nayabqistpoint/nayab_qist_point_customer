import 'package:flutter/material.dart';
import 'cash_account_args.dart';
import 'cash_account_controller.dart';
import 'components/cash_loan_balance_summary_ui.dart';
import 'components/cash_loan_accordion_card_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/features/grocery_entry/grocery_entry_page.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/features/stock_entry/stock_entry_page.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/features/transfer_to_installment/transfer_to_installment_sheet_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/features/universal_payment_feature/universal_payment_page.dart';

class CashAccountPage extends StatefulWidget {
  final CashAccountArgs args;

  const CashAccountPage({
    super.key,
    required this.args,
  });

  @override
  State<CashAccountPage> createState() => _CashAccountPageState();
}

class _CashAccountPageState extends State<CashAccountPage> {
  late final CashAccountController controller;

  @override
  void initState() {
    super.initState();
    controller = CashAccountController(
      customerPhone: widget.args.customerPhone,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF0F172A),
          title: const Text(
            'نقد کھاتہ تفصیلات',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final computedList = controller.computedEntries;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CashLoanBalanceSummaryUi(
                    cashLoanBalance: controller.cashLoanBalance,
                    formatAmount: controller.formatAmount,
                    onRepaymentPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UniversalPaymentPage(
                            title: 'نقد کھاتہ واپسی ادائیگی',
                            baseAmount: controller.cashLoanBalance.abs(),
                            isInstallment: false,
                            itemName: 'دستی نقد ادھار',
                          ),
                        ),
                      );
                      controller.loadFromHive();
                    },
                    onTransferPressed: () {
                      final int greenAdvance = controller.cashLoanBalance < 0
                          ? controller.cashLoanBalance.abs()
                          : 0;
                      TransferToInstallmentSheetUi.show(
                        context: context,
                        customerPhone: controller.customerPhone,
                        availableGreenAdvance: greenAdvance,
                        customerProducts: controller.customerProducts,
                        formatAmount: controller.formatAmount,
                      );
                    },
                    onGroceryPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GroceryEntryPage(customerPhone: controller.customerPhone),
                        ),
                      );
                      controller.loadFromHive();
                    },
                    onStockPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StockEntryPage(customerPhone: controller.customerPhone),
                        ),
                      );
                      controller.loadFromHive();
                    },
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'نقد کھاتہ ریکارڈ و تفصیلات (تاریخ وار رننگ بیلنس):',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                  ),
                  const SizedBox(height: 12),
                  if (computedList.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Center(
                        child: Text(
                          'نقد کھاتے میں ابھی تک کوئی اندراج موجود نہیں ہے۔',
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ),
                    )
                  else
                    ...computedList.asMap().entries.map((item) {
                      final index = item.key;
                      final entry = item.value;
                      final isExpanded = controller.expandedIndices.contains(index);
                      return CashLoanAccordionCardUi(
                        entry: entry,
                        isExpanded: isExpanded,
                        onToggle: () => controller.toggleAccordion(index),
                        formatAmount: controller.formatAmount,
                      );
                    }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}