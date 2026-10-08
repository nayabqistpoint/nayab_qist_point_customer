import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/service_stock_entry_page.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/universal_payment_feature/universal_payment_page.dart';

class CustomerSessionContextService {
  static String _activePhone = '';

  /// سیشن میں موجود موجودہ ایکٹو کسٹمر کا فون نمبر
  static String get currentPhone => _activePhone;

  /// سیشن کا فون دستی طور پر سیٹ کرنا (مثلاً روٹ آرگیومنٹس سے)
  static void setActivePhone(String phone) {
    if (phone.trim().isNotEmpty) {
      _activePhone = phone.trim();
    }
  }

  /// محفوظ طریقے سے ایکٹو کسٹمر کا فون حاصل کرنا
  static Future<String> resolveActivePhone({String? fallbackPhone}) async {
    if (fallbackPhone != null && fallbackPhone.trim().isNotEmpty) {
      _activePhone = fallbackPhone.trim();
      return _activePhone;
    }

    if (_activePhone.isNotEmpty) {
      return _activePhone;
    }

    try {
      final settingsBox = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
      final phone = settingsBox.get('activePhone') ?? 
                    settingsBox.get('remembered_phone') ?? 
                    settingsBox.get('last_logged_phone');
      if (phone != null && phone.toString().trim().isNotEmpty) {
        _activePhone = phone.toString().trim();
      }
    } catch (_) {}

    return _activePhone;
  }

  /// 🎯 سروس و اسٹاک انٹری پیج نیویگیشن
  static Future<dynamic> openServiceStockEntry(
    BuildContext context, {
    required String customerPhone,
    required List<Map<String, dynamic>> products,
  }) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceStockEntryPage(
          customerPhone: customerPhone,
          customerProducts: products,
        ),
      ),
    );
  }

  /// 🎯 یونیورسل پیمنٹ پیج نیویگیشن
  static Future<dynamic> openUniversalPayment(
    BuildContext context, {
    required String title,
    required int baseAmount,
    required bool isInstallment,
    String? itemName,
    String? planTitle,
    int? installmentNo,
    int? maxAllowedAmount,
  }) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UniversalPaymentPage(
          title: title,
          baseAmount: baseAmount,
          isInstallment: isInstallment,
          itemName: itemName,
          planTitle: planTitle,
          installmentNo: installmentNo,
          maxAllowedAmount: maxAllowedAmount,
        ),
      ),
    );
  }
}