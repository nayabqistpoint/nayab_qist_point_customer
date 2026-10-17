import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/features/transaction_history/transaction_history_args.dart';

class LedgerActionHandlerService {
  static Future<void> openCustomerStatement(
    BuildContext context,
    String phone,
    String Function(int) format,
  ) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.transactionHistory,
      arguments: TransactionHistoryArgs(customerPhone: phone),
    );
  }
}