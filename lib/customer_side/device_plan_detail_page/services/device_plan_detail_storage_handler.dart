import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/services/calculator_config_model.dart';

class DevicePlanDetailStorageHandler {
  static const String configDocKey = 'calculator_config';

  static CalculatorConfigModel getCalculatorConfig() {
    try {
      if (Hive.isBoxOpen(HiveBoxManager.appConfigBoxName)) {
        final box = Hive.box(HiveBoxManager.appConfigBoxName);
        final rawData = box.get(configDocKey);
        if (rawData is Map) {
          return CalculatorConfigModel.fromMap(rawData);
        }
      }
    } catch (_) {}
    return CalculatorConfigModel.fallback();
  }

  static Future<CalculatorConfigModel> loadConfigAsync() async {
    try {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.appConfigBoxName);
      final rawData = box.get(configDocKey);
      if (rawData is Map) {
        return CalculatorConfigModel.fromMap(rawData);
      }
    } catch (_) {}
    return CalculatorConfigModel.fallback();
  }
}