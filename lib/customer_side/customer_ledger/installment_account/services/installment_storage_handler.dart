import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';

class InstallmentStorageHandler {
  InstallmentStorageHandler._();

  static Future<Box> ensureBoxOpen() async {
    return await HiveBoxManager.openSafeBox(HiveBoxManager.installmentsBoxName);
  }

  static ValueListenable<Box>? get installmentsListenable {
    if (Hive.isBoxOpen(HiveBoxManager.installmentsBoxName)) {
      return Hive.box(HiveBoxManager.installmentsBoxName).listenable();
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> fetchRawInstallmentOrders() async {
    final box = await ensureBoxOpen();
    final List<Map<String, dynamic>> list = [];

    for (var key in box.keys) {
      final rawData = box.get(key);
      if (rawData is Map) {
        final Map<String, dynamic> entry = Map<String, dynamic>.from(rawData);
        entry['orderKey'] = key;
        list.add(entry);
      }
    }
    return list;
  }
}