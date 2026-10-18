import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';

class ShowcaseConfigService {
  static const String configDocKey = 'shop_showcase_config';

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
}