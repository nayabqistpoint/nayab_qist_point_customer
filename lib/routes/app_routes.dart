import 'package:flutter/material.dart';

import 'package:nayab_qist_point_customer/customer_login_page.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger_view.dart';
import 'package:nayab_qist_point_customer/customer_side/universal_payment_page.dart';
import 'package:nayab_qist_point_customer/customer_side/service_stock_entry_page.dart';

// 🎯 نئے ماڈیولر پیجز کی امپورٹس
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/purchase_market_page.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/device_plan_detail_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String ledger = '/ledger';
  static const String purchaseMarket = '/purchase-market'; // 👈 پہلا صفحہ (مارکیٹ شو روم)
  static const String planDetail = '/plan-detail';         // 👈 دوسرا صفحہ (28 اقساط شیڈول)
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

      // 🛒 1. مارکیٹ شو روم روٹ
      case purchaseMarket:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => PurchaseMarketPage(
            customerPhone: args['customerPhone'],
          ),
        );

      // 📑 2. تفصیلی 28 پلانز روٹ
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