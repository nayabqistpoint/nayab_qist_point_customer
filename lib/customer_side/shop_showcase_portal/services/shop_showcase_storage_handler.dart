import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';

class ShopShowcaseStorageHandler {
  static const String configDocKey = 'shop_showcase_config';

  /// ایڈمن کی سیٹ کردہ شوکیس کنفگریشن حاصل کرنا
  static Future<Map<String, dynamic>> loadShowcaseConfig() async {
    try {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.appConfigBoxName);
      final rawData = box.get(configDocKey);
      if (rawData is Map) {
        return Map<String, dynamic>.from(rawData);
      }
    } catch (_) {}

    return {
      'shop_info': {
        'patron_name': 'حافظ محمد صابر مونڈ',
        'patron_role': 'پروپرائیٹر و نگرانِ اعلیٰ',
        'shop_name': 'نایاب قسط پوائنٹ',
        'address': 'ہیڈ اسلام روڈ، نزد گورنمنٹ بوائز ہائی اسکول، قائم پور',
        'whatsapp': '0323 1988351',
      },
      'policies': {
        'privacy_title': '🛡️ کسٹمر کی عزت و رازداری کی 100% ضمانت',
        'privacy_desc':
            'قسطوں پر خریداری آپ کا نجی معاملہ ہے۔ کسی بھی صارف کا نام، چہرہ یا ڈلیوری ویڈیو کبھی تشہیر کے لیے ظاہر نہیں کی جاتی۔ لائیو شیڈول پر شفافیت کے لیے صرف آفیشل ٹوکن (#NQP-408) نظر آتا ہے۔',
        'prize_title': '🎁 ماہانہ انعامی قرعہ اندازی و زیرو ایڈوانس',
        'prize_desc':
            'تمام اقساط تاریخ پر جمع کرانے والے معزز کسٹمرز کو خصوصی لکی ڈرا میں شامل کیا جائے گا اور اگلی ڈیوائس پر 0% ایڈوانس کی خصوصی رعایت دی جائے گی۔',
      },
      'audio_announcement': {
        'audio_url': '',
        'duration_text': '0:42 سیکنڈ',
      },
      'media_showcase': <Map<String, dynamic>>[],
    };
  }

  /// ایڈمن کے کیلکولیٹر کنفگ ڈاکومنٹ سے کل پیکجز کی تعداد لانا
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

  /// ایڈمن کے کوٹہ ڈاکومنٹ سے ماہانہ موبائل کوٹہ کی تفصیلات لانا
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