import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';

class PlanCounterService {
  static Future<int> getAvailablePlansCount() async {
    try {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.appConfigBoxName);
      final calcConfig = box.get('calculator_config');
      if (calcConfig is Map) {
        final durations = calcConfig['allowedDurations'] ?? calcConfig['durations'];
        final plansPerDuration = calcConfig['plansPerDuration'] ?? 4;
        if (durations is List && durations.isNotEmpty) {
          return durations.length * (plansPerDuration is int ? plansPerDuration : 4);
        }
      }
    } catch (_) {}
    return 36;
  }
}