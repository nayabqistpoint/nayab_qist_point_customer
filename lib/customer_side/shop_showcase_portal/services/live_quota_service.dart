import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';

class LiveQuotaService {
  static Future<Map<String, int>> getMonthlyQuotaMetrics() async {
    int totalQuota = 10;
    const int delivered = 6;
    try {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.appConfigBoxName);
      final quotaConfig = box.get('quota_config');
      if (quotaConfig is Map) {
        totalQuota = (quotaConfig['monthly_mobile_quota'] as num?)?.toInt() ?? 10;
      }
    } catch (_) {}

    return {
      'total': totalQuota,
      'delivered': delivered,
      'remaining': (totalQuota - delivered).clamp(0, totalQuota),
    };
  }
}