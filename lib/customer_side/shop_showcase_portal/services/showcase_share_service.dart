// lib/customer_side/shop_showcase_portal/services/showcase_share_service.dart

class ShowcaseShareService {
  static String generateShareText({
    required String shopName,
    required String patronName,
    required String address,
    required String whatsapp,
    required int plansCount,
  }) {
    return '📢 $shopName (قائم پور)\n'
        'نگرانِ اعلیٰ: $patronName\n\n'
        '✨ ہر موبائل پر $plansCount آسان اقساط پلانز دستیاب ہیں!\n'
        '⚡ چھوٹے گھریلو الیکٹرانکس بغیر سلاٹ کے 24 گھنٹے میں دستیاب۔\n'
        '🛡️ کسٹمر کی عزت و رازداری کی 100% ضمانت۔\n\n'
        '📍 پتہ: $address\n'
        '📞 واٹس ایپ رابطہ: $whatsapp';
  }
}