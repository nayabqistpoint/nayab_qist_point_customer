import 'package:flutter/material.dart';

// 🎯 کسٹمر ایپ کے درست امپورٹ پاتھس:
import 'package:nayab_qist_point_customer/ledger/customer_ledger/customer_ledger_controller.dart';
import 'package:nayab_qist_point_customer/ledger/pay_now/pay_now_widget.dart';
import 'package:nayab_qist_point_customer/ledger/purchase_now/purchase_now.dart';

class LedgerBottomHelper {
  static Future<void> handleLeftButton(
          BuildContext context, CustomerLedgerController controller) =>
      _navigateAndReload(
        context,
        controller,
        PurchaseNow(customerMobileNumber: controller.customerPhone),
      );

  static Future<void> handleRightButton(
          BuildContext context, CustomerLedgerController controller) =>
      _navigateAndReload(
        context,
        controller,
        PayNowWidget(customerMobileNumber: controller.customerPhone),
      );

  static Future<void> _navigateAndReload(
    BuildContext context,
    CustomerLedgerController controller,
    Widget targetScreen,
  ) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (_) => targetScreen));
    controller.loadLedgerData();
  }
}