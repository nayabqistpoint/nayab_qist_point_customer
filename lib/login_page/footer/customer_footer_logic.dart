import 'package:flutter/material.dart';

// 🎯 سینٹرلائزڈ روٹس فائل کی امپورٹ
import 'package:nayab_qist_point_customer/routes/app_routes.dart';
import 'package:nayab_qist_point_customer/signup_page/signup_page.dart';

class CustomerFooterLogic {
  // 🎯 نیا اکاؤنٹ (سائن اپ) پیج پر جانے کی لاجک
  void handleSignUpNavigation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignupPage(),
      ),
    );
  }

  // 🎯 آن لائن قسط کیلکولیٹر اور پبلک شو روم پیج پر جانے کی لاجک
  void handleCalculatorNavigation(BuildContext context) {
    // بغیر کسی موبائل نمبر کے پبلک شو روم کھولنا
    Navigator.pushNamed(
      context,
      AppRoutes.purchaseMarket,
    );
  }
}