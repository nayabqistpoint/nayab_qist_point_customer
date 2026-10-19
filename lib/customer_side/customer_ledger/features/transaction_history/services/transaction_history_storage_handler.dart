import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';

class TransactionHistoryStorageHandler {
  TransactionHistoryStorageHandler._();

  static Future<Box> ensureBoxOpen() async {
    return await HiveBoxManager.openSafeBox(HiveBoxManager.transactionBoxName);
  }

  static ValueListenable<Box>? get boxListenable {
    if (Hive.isBoxOpen(HiveBoxManager.transactionBoxName)) {
      return Hive.box(HiveBoxManager.transactionBoxName).listenable();
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> fetchRawTransactions() async {
    final box = await ensureBoxOpen();
    final List<Map<String, dynamic>> rawList = [];

    for (var key in box.keys) {
      final rawData = box.get(key);
      if (rawData is Map) {
        final Map<String, dynamic> entry = Map<String, dynamic>.from(rawData);
        entry['key'] = key;
        rawList.add(entry);
      }
    }
    return rawList;
  }
}