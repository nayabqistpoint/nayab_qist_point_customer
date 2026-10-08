import 'package:flutter/material.dart';

import 'package:nayab_qist_point_customer/customer_side/login/customer_login_page.dart';
import 'package:nayab_qist_point_customer/customer_side/auth/customer_signup_page.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/main_dashboard/customer_ledger_view.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/purchase_market_page.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/device_plan_detail_page.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/universal_payment_feature/universal_payment_page.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/service_stock_entry_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String customerSignup = '/customer-signup';
  static const String ledger = '/ledger';
  static const String purchaseMarket = '/purchase-market';
  static const String planDetail = '/plan-detail';
  static const String payment = '/payment';
  static const String serviceStock = '/service-stock';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const CustomerLoginPage(),
        );

      case customerSignup:
        return MaterialPageRoute(
          builder: (_) => const CustomerSignupPage(),
        );

      case ledger:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => CustomerLedgerView(
            customerPhone: args['customerPhone'],
          ),
        );

      case purchaseMarket:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => PurchaseMarketPage(
            customerPhone: args['customerPhone'],
          ),
        );

      case planDetail:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => DevicePlanDetailPage(
            device: args['device'] ?? {},
            customerPhone: args['customerPhone'],
          ),
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
        return MaterialPageRoute(
          builder: (_) => ServiceStockEntryPage(
            customerPhone: args['customerPhone']?.toString() ?? '',
            customerProducts: (args['customerProducts'] as List?)?.cast<Map<String, dynamic>>() ?? const [],
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