import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// 🎯 قسط کیلکولیٹر پیج کا امپورٹ
import 'package:nayab_qist_point_customer/calculator/installment_calculator_page.dart';

class CustomerLedgerController extends ChangeNotifier {
  final String customerPhone;

  bool isLoading = true;
  Map<String, dynamic>? customerDetails;

  CustomerLedgerController({required this.customerPhone}) {
    loadCustomerProfile();
  }

  /// 🟢 ۱۔ پرانی فائلوں اور Helpers کی مطابقت کے لیے Alias میتھڈ (بامشمول ledger_bottom_helper)
  Future<void> loadLedgerData() async {
    await loadCustomerProfile();
  }

  /// 🟢 ۲۔ کسٹمر کی مکمل پروفائل معلومات اور فون نمبر لوڈ کرنا (جو باٹم ہیلپر کو پاس ہوتی ہیں)
  Future<void> loadCustomerProfile() async {
    isLoading = true;
    notifyListeners();

    try {
      final customerBox = Hive.isBoxOpen('customerBox') 
          ? Hive.box('customerBox') 
          : await Hive.openBox('customerBox');
      final usersBox = Hive.isBoxOpen('usersBox') 
          ? Hive.box('usersBox') 
          : await Hive.openBox('usersBox');

      dynamic rawCustomer = customerBox.get(customerPhone) ?? usersBox.get(customerPhone);

      if (rawCustomer != null) {
        customerDetails = Map<String, dynamic>.from(rawCustomer as Map);
      } else {
        customerDetails = {
          'phone': customerPhone,
          'customerPhone': customerPhone,
          'customerName': 'کسٹمر ($customerPhone)',
        };
      }
    } catch (e) {
      debugPrint('❌ [LedgerController Error] $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🟢 ۳۔ قسط کیلکولیٹر کا صفحہ کھولنے کا میتھڈ
  void openInstallmentCalculator(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InstallmentCalculaterPage(),
      ),
    );
  }
}