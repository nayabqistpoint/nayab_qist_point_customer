import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';

class InstallmentStorageHandler {
  /// ہائیو سے کسٹمر کے تمام کچے آرڈرز پڑھنا
  static Future<List<Map<dynamic, dynamic>>> getCustomerRawOrders(String customerPhone) async {
    final box = await HiveBoxManager.openSafeBox(HiveBoxManager.installmentsBoxName);
    final cleanPhone = customerPhone.replaceAll(RegExp(r'\s+'), '').trim();
    final List<Map<dynamic, dynamic>> list = [];

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
          list.add({
            'orderKey': key,
            ...Map<dynamic, dynamic>.from(rawData),
          });
        }
      }
    }
    return list;
  }

  /// ہائیو باکس کے لائیو مشاہدے کے لیے لسن ایبل
  static ValueListenable<Box>? get installmentsListenable {
    return HiveBoxManager.listenBox(HiveBoxManager.installmentsBoxName);
  }
}