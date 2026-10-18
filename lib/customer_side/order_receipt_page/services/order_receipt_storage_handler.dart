import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';

class OrderReceiptStorageHandler {
  static const String installmentsBoxName = HiveBoxManager.installmentsBoxName;

  static Future<Box> getInstallmentsBox() async {
    return await HiveBoxManager.openSafeBox(installmentsBoxName);
  }

  static Future<void> saveOrderRecord({
    required String tokenNo,
    required Map<String, dynamic> payload,
  }) async {
    final box = await getInstallmentsBox();
    await box.put(tokenNo, payload);
  }
}