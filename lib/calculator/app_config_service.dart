import 'package:hive_flutter/hive_flutter.dart';

class AppConfigService {
  /// calculator_config ڈاکیومنٹ سے مخصوص فیلڈ فیچ کرنے کا جنرل میتھڈ
  static dynamic getValue(String key, {dynamic defaultValue}) {
    try {
      if (!Hive.isBoxOpen('appConfigBox')) {
        return defaultValue;
      }

      final box = Hive.box('appConfigBox');
      final rawData = box.get('calculator_config');

      if (rawData != null && rawData is Map) {
        return rawData[key] ?? defaultValue;
      }
    } catch (_) {}
    return defaultValue;
  }

  // 🟢 ۱۔ بنیادی فارمولا فیصد ویلیوز (اگر فائر سٹور میں 25 ہو یا 0.25)
  static double get profitWithCheck {
    final val = (getValue('profitWithCheck', defaultValue: 0.25) as num).toDouble();
    return val > 1 ? val / 100 : val; // خودکار 0.25 میں تبدیل کرے گا
  }

  static double get profitWithoutCheck {
    final val = (getValue('profitWithoutCheck', defaultValue: 0.35) as num).toDouble();
    return val > 1 ? val / 100 : val;
  }

  static double get perMonthIncrement {
    final val = (getValue('perMonthIncrement', defaultValue: 0.05) as num).toDouble();
    return val > 1 ? val / 100 : val;
  }

  // 🟢 ۲۔ لائیو پروسیسنگ فیس (جو تمام پیکجز کی کل رقم میں جمع ہوگی)
  static double get processingFee =>
      (getValue('processingFee', defaultValue: 0) as num).toDouble();

  // 🟢 ۳۔ رابطہ کی تفصیلات
  static String get contactNumber =>
      getValue('contactNumber', defaultValue: '03012700351').toString();

  static String get contactName =>
      getValue('contactName', defaultValue: 'حافظ محمد صابر').toString();
}