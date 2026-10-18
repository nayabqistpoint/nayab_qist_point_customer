import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';

class PurchaseMarketStorageHandler {
  static const String boxName = HiveBoxManager.stockBoxName;

  static ValueListenable<Box>? get stockListenable {
    return HiveBoxManager.listenBox(boxName);
  }

  static List<dynamic> getAllRawStock() {
    try {
      if (!Hive.isBoxOpen(boxName)) return const [];
      final currentBox = Hive.box(boxName);
      return currentBox.keys.map((k) {
        final val = currentBox.get(k);
        return {'key': k, 'data': val};
      }).toList();
    } catch (_) {
      return const [];
    }
  }
}