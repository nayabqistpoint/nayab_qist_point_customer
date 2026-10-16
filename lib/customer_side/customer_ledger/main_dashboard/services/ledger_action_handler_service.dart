import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/cash_account/services/transaction_ledger_service.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/main_dashboard/components/customer_statement_sheet_ui.dart';

class LedgerActionHandlerService {
  // کسٹمر اسٹیٹمنٹ پاس بک کھولنا
  static Future<void> openCustomerStatement(
    BuildContext context,
    String phone,
    String Function(int) format,
  ) async {
    await TransactionLedgerService.ensureBoxOpen();
    final txs = await TransactionLedgerService.getCustomerTransactions(phone);
    if (context.mounted) {
      CustomerStatementSheetUi.show(
        context,
        transactions: txs,
        formatAmount: format,
      );
    }
  }
}