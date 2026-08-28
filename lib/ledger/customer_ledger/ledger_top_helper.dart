import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// 🎯 shared فولڈر کا درست امپورٹ پاتھ:
import 'package:nayab_qist_point_customer/shared_widgets/installment_plan_dialog.dart';
import 'package:nayab_qist_point_customer/ledger/customer_ledger/balance_helper.dart';

class LedgerTopHelper {
  /// 🎯 موبائل نمبر کی بنیاد پر کسٹمر کا نام اور ٹائٹل جنریٹ کرنا
  static String getHeaderTitle({
    Map<String, dynamic>? customerDetails,
    String? customerPhone,
    dynamic customer,
    Map<String, dynamic>? customerData,
    bool isAdmin = false,
  }) {
    String phone = customerPhone ?? customerDetails?['phone'] ?? customerDetails?['customerPhone'] ?? '';
    
    if (phone.isEmpty && customerData != null) {
      phone = (customerData['customerPhone'] ?? customerData['phone'] ?? '').toString();
    }
    
    phone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    String name = '';
    String cast = '';

    // ۱۔ customerBox سے ڈیٹا تلاش کرنا
    if (phone.isNotEmpty && Hive.isBoxOpen('customerBox')) {
      final box = Hive.box('customerBox');
      for (final val in box.values.whereType<Map>()) {
        final p = (val['phone'] ?? val['mobile'] ?? val['customerPhone'] ?? val['customerId'] ?? '')
            .toString()
            .replaceAll(RegExp(r'[^0-9]'), '');
        if (p == phone) {
          name = (val['name'] ?? val['customerName'] ?? val['fullName'] ?? '').toString().trim();
          cast = (val['cast'] ?? val['caste'] ?? val['customerCaste'] ?? '').toString().trim();
          break;
        }
      }
    }

    // ۲۔ اگر باکس سے نہ ملے تو لوکل ڈائریکٹ میپ سے اٹھانا
    if (name.isEmpty) {
      final source = customerDetails ?? customerData;
      if (source != null) {
        name = (source['name'] ?? source['customerName'] ?? '').toString().trim();
        cast = (source['cast'] ?? source['caste'] ?? '').toString().trim();
      }
    }

    // ۳۔ کسٹمر ایپ کے لیے صاف ستھرا ٹائٹل فارمیٹ
    if (name.isNotEmpty) {
      return cast.isNotEmpty ? "نایاب قسط پوائنٹ ($name $cast)" : "نایاب قسط پوائنٹ ($name)";
    }
    return "نایاب قسط پوائنٹ";
  }

  static Map<String, dynamic> getBalanceData(Box box, String customerPhone) {
    final double balance = BalanceHelper.calculateCustomerBalance(box, customerPhone);
    return {
      'amount': balance.abs().toStringAsFixed(0),
      'color': BalanceHelper.getAmountColor(balance),
      'label': balance >= 0 ? "بقایا لینا / ایڈوانس" : "بقایا دینا ہے",
    };
  }

  static double getShortAmount(String customerPhone) => InstallmentPlanDialog.calculateTotalShort(customerPhone);

  static void openInstallmentDialog(BuildContext context, String customerPhone, [bool isAdmin = false]) {
    showDialog(
      context: context,
      builder: (_) => InstallmentPlanDialog(customerPhone: customerPhone),
    );
  }

  static BoxDecoration boxDecoration(Color borderClr, Color shadowClr) => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderClr, width: 1.5),
        boxShadow: [BoxShadow(color: shadowClr, blurRadius: 8, offset: const Offset(0, 4))],
      );
}