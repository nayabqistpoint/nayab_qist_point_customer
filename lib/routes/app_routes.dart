import 'package:flutter/material.dart';

// 🎯 تمام امپورٹس اب آپ کے پب اسپیک کے اصل نام (nayab_qist_point_customer) پر ہیں
import 'package:nayab_qist_point_customer/customer_login_page.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger_view.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_page.dart';
import 'package:nayab_qist_point_customer/customer_side/universal_payment_page.dart';
import 'package:nayab_qist_point_customer/customer_side/service_stock_entry_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String ledger = '/ledger';
  static const String purchase = '/purchase';
  static const String payment = '/payment';
  static const String serviceStock = '/service-stock';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const CustomerLoginPage(),
        );

      case ledger:
        return MaterialPageRoute(
          builder: (_) => const CustomerLedgerView(),
        );

      case purchase:
        return MaterialPageRoute(
          builder: (_) => const PurchasePage(),
        );

      case payment:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => UniversalPaymentPage(
            title: args['title'] ?? 'ادائیگی',
            baseAmount: args['baseAmount'] ?? 0,
            isInstallment: args['isInstallment'] ?? false,
          ),
        );

      case serviceStock:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final targetAccounts = (args['targetAccounts'] as List<String>?) ??
            const ['نیا / آزاد کسٹمر کریڈٹ کھاتہ'];
        return MaterialPageRoute(
          builder: (_) => ServiceStockEntryPage(
            targetAccounts: targetAccounts,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('صفحہ نہیں مل سکا!')),
          ),
        );
    }
  }
}