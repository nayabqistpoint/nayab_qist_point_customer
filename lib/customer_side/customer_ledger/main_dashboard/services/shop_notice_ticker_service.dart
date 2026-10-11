import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';

class ShopNoticeTickerService {
  /// टिकर का लाइव टेक्स्ट
  static String get liveTickerText =>
      '📢 نایاب قسط پوائنٹ: ماہانہ موبائل کوٹہ (10 میں سے 6 ڈلیور) • 36 پلانز کی سلیکشن دکان پر جاری • چھوٹے الیکٹرانکس (جوسر، استری، واشنگ مشین) بغیر کسی سلاٹ کے 24 گھنٹے میں دستیاب • کسٹمر نام و تصویر کی 100% رازداری ہماری اولین پالیسی ہے • رابطہ: 0323 1988351 (حافظ محمد صابر مونڈ) • ';

  /// "شیڈول دیکھیں" पर क्लिक करने पर नया इंडिपेंडेंट शोकेस पोर्टल पेज खोलना
  static void openShowcasePortal(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.shopShowcase);
  }
}