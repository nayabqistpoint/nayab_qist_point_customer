import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:nayab_qist_point_customer/shared_widgets/installment_plan_dialog.dart';
import 'package:nayab_qist_point_customer/ledger/customer_ledger/ledger_listener.dart';
import 'package:nayab_qist_point_customer/services/master_sync_manager.dart';

class LedgerTopHelper {
  /// 🎯 سنک پروسیس چلانا اور SnackBar دکھانا
  static Future<void> triggerSync(BuildContext context, String phone) async {
    await MasterSyncManager().runFullSync(phone);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ڈیٹا کامیابی سے سنک ہو گیا ہے'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// 🎯 آخری سنک کا وقت اور تاریخ الگ الگ فارمیٹ میں حاصل کرنا (RTL کے لیے)
  static Map<String, String> getFormattedSyncData() {
    try {
      if (!Hive.isBoxOpen('settingsBox')) {
        return {'time': '--:--', 'period': '', 'date': '--/--/----'};
      }
      final box = Hive.box('settingsBox');
      final timeStr = box.get('lastSyncedTime');
      if (timeStr == null) {
        return {'time': '--:--', 'period': '', 'date': '--/--/----'};
      }

      final dateTime = DateTime.parse(timeStr).toLocal();

      int hour = dateTime.hour;
      final String period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12;

      final String formattedHour = hour.toString().padLeft(2, '0');
      final String minute = dateTime.minute.toString().padLeft(2, '0');
      final String day = dateTime.day.toString().padLeft(2, '0');
      final String month = dateTime.month.toString().padLeft(2, '0');

      return {
        'time': '$formattedHour:$minute',
        'period': period,
        'date': '$day/$month/${dateTime.year}',
      };
    } catch (_) {
      return {'time': '--:--', 'period': '', 'date': '--/--/----'};
    }
  }

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

    if (name.isEmpty) {
      final source = customerDetails ?? customerData;
      if (source != null) {
        name = (source['name'] ?? source['customerName'] ?? '').toString().trim();
        cast = (source['cast'] ?? source['caste'] ?? '').toString().trim();
      }
    }

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