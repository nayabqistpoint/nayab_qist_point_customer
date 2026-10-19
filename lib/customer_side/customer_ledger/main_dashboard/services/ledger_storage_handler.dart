import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';

class LedgerStorageHandler {
  LedgerStorageHandler._();

  static Future<void> ensureRequiredBoxesOpen() async {
    await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);
    await HiveBoxManager.openSafeBox(HiveBoxManager.installmentsBoxName);
    await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
  }

  static ValueListenable<Box>? get customerBoxListenable {
    if (Hive.isBoxOpen(HiveBoxManager.customerBoxName)) {
      return Hive.box(HiveBoxManager.customerBoxName).listenable();
    }
    return null;
  }

  static Future<String> resolveActivePhone() async {
    try {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
      final phone = box.get('activePhone') ??
          box.get('remembered_phone') ??
          box.get('last_logged_phone');
      if (phone != null && phone.toString().trim().isNotEmpty) {
        return phone.toString().trim();
      }
    } catch (_) {}
    return '';
  }

  static Future<int> getCustomerCashBalance(String customerPhone) async {
    try {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);
      final custData = box.get(customerPhone);
      if (custData is Map) {
        return (custData['cashLoanBalance'] as num?)?.toInt() ?? 0;
      }
    } catch (_) {}
    return 0;
  }

  static Future<List<Map<String, dynamic>>> fetchRawInstallmentOrders(String customerPhone) async {
    final cleanPhone = customerPhone.replaceAll(RegExp(r'\s+'), '').trim();
    final List<Map<String, dynamic>> results = [];
    try {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.installmentsBoxName);
      for (var key in box.keys) {
        final rawData = box.get(key);
        if (rawData is Map) {
          final orderPhone = (rawData['customerPhone'] ?? '')
              .toString()
              .replaceAll(RegExp(r'\s+'), '')
              .trim();
          final bool isMatch = cleanPhone.isNotEmpty &&
              (orderPhone == cleanPhone ||
                  (cleanPhone.length >= 10 && orderPhone.endsWith(cleanPhone.substring(cleanPhone.length - 10))));
          if (isMatch) {
            final Map<String, dynamic> item = Map<String, dynamic>.from(rawData);
            item['key'] = key;
            results.add(item);
          }
        }
      }
    } catch (_) {}
    return results;
  }
}