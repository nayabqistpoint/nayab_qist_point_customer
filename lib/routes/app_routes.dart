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
  static const String purchaseMarket = '/purchase-market'; // 👈 شو روم پیج
  static const String planDetail = '/plan-detail';         // 👈 28 اقساط پیج
  static const String payment = '/payment';
  static const String serviceStock = '/service-stock';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const CustomerLoginPage(),
        );

      // 👤 1. کسٹمر لیجر پیج (لاگ ان کے فوراً بعد)
      case ledger:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => CustomerLedgerView(
            customerPhone: args['customerPhone'],
          ),
        );

      // 🛒 2. نیا موبائل خریدیں شو روم پیج
      case purchaseMarket:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => PurchaseMarketPage(
            customerPhone: args['customerPhone'],
          ),
        );

      // 📑 3. تفصیلی 28 پلانز پیج
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