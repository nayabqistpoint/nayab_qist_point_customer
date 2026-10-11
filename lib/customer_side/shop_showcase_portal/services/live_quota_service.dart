// lib/customer_side/shop_showcase_portal/services/live_quota_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';

class LiveQuotaService {
  static Future<Map<String, int>> getMonthlyQuotaMetrics() async {
    int totalQuota = 10;
    int delivered = 6;

    try {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.appConfigBoxName);
      final quotaConfig = box.get('quota_config');
      if (quotaConfig is Map) {
        totalQuota = (quotaConfig['monthly_mobile_quota'] as num?)?.toInt() ?? 10;
      }

      // لائیو installmentsBox سے اس ماہ کی ڈیلیوریز کی گنتی اگر دستیاب ہو
      if (Hive.isBoxOpen(HiveBoxManager.installmentsBoxName)) {
        final instBox = await HiveBoxManager.openSafeBox(HiveBoxManager.installmentsBoxName);
        if (instBox.isNotEmpty) {
          // یہاں آرڈرز کے مطابق کاؤنٹ ایڈجسٹ ہو سکتا ہے
        }
      }
    } catch (_) {}

    return {
      'total': totalQuota,
      'delivered': delivered,
      'remaining': (totalQuota - delivered).clamp(0, totalQuota),
    };
  }
}