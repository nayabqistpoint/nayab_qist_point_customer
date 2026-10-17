import 'package:flutter/material.dart';

import 'package:nayab_qist_point_customer/customer_side/login/customer_login_page.dart';
import 'package:nayab_qist_point_customer/customer_side/auth/customer_signup_page.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/main_dashboard/customer_ledger_view.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_account/installment_account_page.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_account/installment_args.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/cash_account/cash_account_page.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/cash_account/cash_account_args.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/features/transaction_history/transaction_history_page.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/features/transaction_history/transaction_history_args.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/purchase_market_page.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/device_plan_detail_page.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/features/universal_payment_feature/universal_payment_page.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/shop_showcase_portal_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String customerSignup = '/customer-signup';
  static const String ledger = '/ledger';
  static const String installmentAccount = '/installment-account';
  static const String cashAccount = '/cash-account';
  static const String transactionHistory = '/transaction-history';
  static const String purchaseMarket = '/purchase-market';
  static const String planDetail = '/plan-detail';
  static const String payment = '/payment';
  static const String shopShowcase = '/shop-showcase';

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

      case installmentAccount:
        final rawArgs = settings.arguments;
        final InstallmentArgs args = rawArgs is InstallmentArgs
            ? rawArgs
            : InstallmentArgs.fromMap(rawArgs as Map<String, dynamic>? ?? {});
        return MaterialPageRoute(
          builder: (_) => InstallmentAccountPage(args: args),
        );

      case cashAccount:
        final rawArgs = settings.arguments;
        final CashAccountArgs args = rawArgs is CashAccountArgs
            ? rawArgs
            : CashAccountArgs.fromMap(rawArgs as Map<String, dynamic>? ?? {});
        return MaterialPageRoute(
          builder: (_) => CashAccountPage(args: args),
        );

      case transactionHistory:
        final rawArgs = settings.arguments;
        final TransactionHistoryArgs args = rawArgs is TransactionHistoryArgs
            ? rawArgs
            : TransactionHistoryArgs.fromMap(rawArgs as Map<String, dynamic>? ?? {});
        return MaterialPageRoute(
          builder: (_) => TransactionHistoryPage(args: args),
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

      case shopShowcase:
        return MaterialPageRoute(
          builder: (_) => const ShopShowcasePortalPage(),
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