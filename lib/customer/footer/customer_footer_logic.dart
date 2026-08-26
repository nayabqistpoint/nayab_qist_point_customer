import 'package:flutter/material.dart';

// 🎯 آپ کی ڈائریکٹری سٹرکچر کے مطابق بالکل ایکوریٹ پاتھس:
import 'package:nayab_qist_point_customer/shared/installment_calculator_page.dart';
import 'package:nayab_qist_point_customer/customer/signup_page.dart';

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

  // 🎯 آن لائن قسط کیلکولیٹر پیج پر جانے کی لاجک
  void handleCalculatorNavigation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InstallmentCalculaterPage(),
      ),
    );
  }
}