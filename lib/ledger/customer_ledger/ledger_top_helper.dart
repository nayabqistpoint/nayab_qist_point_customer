import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:nayab_qist_point_customer/shared_widgets/installment_plan_dialog_ui.dart';
import 'package:nayab_qist_point_customer/shared_widgets/installment_plan_dialog_logic.dart';
import 'package:nayab_qist_point_customer/ledger/customer_ledger/ledger_listener_service.dart';
import 'package:nayab_qist_point_customer/services/master_sync_manager.dart';
import 'package:nayab_qist_point_customer/services/customer_profile_image_service.dart';

class LedgerTopHelper {
  /// 🎯 mediaBox سے لائیو پروفائل تصویر/اوتار حاصل کرنے کا میتھڈ (آن لائن، آف لائن اور کلک ایبل)
  static Widget buildCustomerAvatar(BuildContext context, String customerPhone, {double radius = 16}) {
    String phone = customerPhone.replaceAll(RegExp(r'[^0-9]'), '');

    if (phone.isEmpty) {
      return CustomerProfileImageService.buildProfileImage(context, null, radius: radius);
    }

    final String docId = "${phone}_customer";

    return ValueListenableBuilder<Box>(
      valueListenable: Hive.isBoxOpen('mediaBox')
          ? Hive.box('mediaBox').listenable()
          : ValueNotifier(Hive.box('mediaBox')),
      builder: (context, box, child) {
        final rawData = box.get(docId);
        String? imageSource;

        if (rawData != null) {
          if (rawData is Map) {
            imageSource = rawData['mediaData']?.toString() ?? 
                          rawData['base64']?.toString() ?? 
                          rawData['filePath']?.toString();
          } else if (rawData is String) {
            imageSource = rawData;
          }
        }

        return CustomerProfileImageService.buildProfileImage(
          context,
          imageSource,
          radius: radius,
        );
      },
    );
  }

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
    String phone = customerPhone ??
        customerDetails?['phone'] ??
        customerDetails?['customerPhone'] ??
        '';

    if (phone.isEmpty && customerData != null) {
      phone = (customerData['customerPhone'] ?? customerData['phone'] ?? '')
          .toString();
    }

    phone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    String name = '';
    String cast = '';

    if (phone.isNotEmpty && Hive.isBoxOpen('customerBox')) {
      final box = Hive.box('customerBox');
      for (final val in box.values.whereType<Map>()) {
        final p = (val['phone'] ??
                val['mobile'] ??
                val['customerPhone'] ??
                val['customerId'] ??
                '')
            .toString()
            .replaceAll(RegExp(r'[^0-9]'), '');
        if (p == phone) {
          name = (val['name'] ?? val['customerName'] ?? val['fullName'] ?? '')
              .toString()
              .trim();
          cast = (val['cast'] ?? val['caste'] ?? val['customerCaste'] ?? '')
              .toString()
              .trim();
          break;
        }
      }
    }

    if (name.isEmpty) {
      final source = customerDetails ?? customerData;
      if (source != null) {
        name = (source['name'] ?? source['customerName'] ?? '')
            .toString()
            .trim();
        cast = (source['cast'] ?? source['caste'] ?? '').toString().trim();
      }
    }

    if (name.isNotEmpty) {
      return cast.isNotEmpty
          ? "نایاب قسط پوائنٹ ($name $cast)"
          : "نایاب قسط پوائنٹ ($name)";
    }
    return "نایاب قسط پوائنٹ";
  }

  /// 🎯 نیا اور اپ ڈیٹڈ بیلنس حساب (txAmount اور txColor کی بنیاد پر)
  static Map<String, dynamic> getBalanceData(Box box, String customerPhone) {
    final processedList = LedgerListenerService.getProcessedTransactions(
      box: box,
      customerPhone: customerPhone,
    );

    double finalBalance = 0.0;
    if (processedList.isNotEmpty) {
      finalBalance = processedList.first.runningBalance;
    }

    Color color;
    if (finalBalance > 0) {
      color = Colors.green.shade700;
    } else if (finalBalance < 0) {
      color = Colors.red.shade700;
    } else {
      color = Colors.black87;
    }

    return {
      'amount': "Rs. ${finalBalance.abs().toStringAsFixed(0)}",
      'color': color,
      'label': finalBalance >= 0 ? "بقایا لینا / ایڈوانس" : "بقایا دینا ہے",
    };
  }

  /// 🎯 اصلی اور لائیو شارٹ اماؤنٹ لاجک
  static double getShortAmount(String customerPhone) {
    return InstallmentPlanDialogLogic.calculateTotalShort(customerPhone);
  }

  /// 🎯 نیا انسٹالمنٹ ڈائیلاگ اوپن کرنے کا میتھڈ
  static void openInstallmentDialog(
      BuildContext context, String customerPhone,
      [bool isAdmin = false]) {
    InstallmentPlanDialogUi.show(context, customerPhone, isAdmin: isAdmin);
  }

  static BoxDecoration boxDecoration(Color borderClr, Color shadowClr) =>
      BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderClr, width: 1.5),
        boxShadow: [
          BoxShadow(
              color: shadowClr, blurRadius: 8, offset: const Offset(0, 4))
        ],
      );
}