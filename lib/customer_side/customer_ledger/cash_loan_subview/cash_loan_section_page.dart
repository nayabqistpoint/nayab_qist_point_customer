import 'package:flutter/material.dart';
import 'cash_loan_section_controller.dart';
import 'components/cash_loan_section_ui.dart';
import 'features/grocery_entry_feature/grocery_entry_page.dart';
import 'features/stock_entry_feature/stock_entry_page.dart';
import 'features/transfer_to_installment_feature/transfer_to_installment_sheet_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/universal_payment_feature/universal_payment_page.dart';

class CashLoanSectionPage extends StatelessWidget {
  final CashLoanSectionController controller;
  final List<Map<String, dynamic>> customerProducts;

  const CashLoanSectionPage({
    super.key,
    required this.controller,
    required this.customerProducts,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return CashLoanSectionUi(
          controller: controller,
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
          },
          onTransferPressed: () {
            final int greenAdvance = controller.cashLoanBalance < 0
                ? controller.cashLoanBalance.abs()
                : 0;
            TransferToInstallmentSheetUi.show(
              context: context,
              customerPhone: controller.customerPhone,
              availableGreenAdvance: greenAdvance,
              customerProducts: customerProducts,
              formatAmount: controller.formatAmount,
            );
          },
          onGroceryPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GroceryEntryPage(customerPhone: controller.customerPhone),
              ),
            );
          },
          onStockPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StockEntryPage(customerPhone: controller.customerPhone),
              ),
            );
          },
        );
      },
    );
  }
}