import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/services/showcase_config_service.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/services/plan_counter_service.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/services/live_quota_service.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/services/slots_feed_service.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/services/showcase_audio_service.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/services/showcase_share_service.dart';

class ShopShowcaseController extends ChangeNotifier {
  final ShowcaseAudioService _audioService = ShowcaseAudioService();

  bool isLoading = true;
  Map<String, dynamic> config = const {};
  int availablePlansCount = 36;
  Map<String, int> quotaMetrics = const {'total': 10, 'delivered': 6, 'remaining': 4};
  List<ShowcaseSlotItem> slots = const [];
  List<Map<String, dynamic>> mediaList = const [];

  bool get isAudioPlaying => _audioService.isPlaying;

  // کلین UI گیٹرز تاکہ پیج کے اندر کوئی میپ یا ہارڈ کوڈڈ سٹرنگ نہ ہو
  Map<String, dynamic> get shopInfo => (config['shop_info'] as Map?)?.cast<String, dynamic>() ?? const {};
  Map<String, dynamic> get audioInfo => (config['audio_announcement'] as Map?)?.cast<String, dynamic>() ?? const {};
  Map<String, dynamic> get policies => (config['policies'] as Map?)?.cast<String, dynamic>() ?? const {};

  String get shopName => shopInfo['shop_name']?.toString() ?? 'نایاب قسط پوائنٹ';
  String get patronName => shopInfo['patron_name']?.toString() ?? 'حافظ محمد صابر مونڈ';
  String get patronRole => shopInfo['patron_role']?.toString() ?? 'پروپرائیٹر و نگرانِ اعلیٰ';
  String get address => shopInfo['address']?.toString() ?? 'ہیڈ اسلام روڈ، نزد گورنمنٹ بوائز ہائی اسکول، قائم پور';
  String get whatsapp => shopInfo['whatsapp']?.toString() ?? '0323 1988351';

  String get audioDurationText => audioInfo['duration_text']?.toString() ?? '0:42 سیکنڈ';
  String get privacyTitle => policies['privacy_title']?.toString() ?? '🛡️ کسٹمر کی عزت و رازداری کی 100% ضمانت';
  String get privacyDesc => policies['privacy_desc']?.toString() ?? '';
  String get prizeTitle => policies['prize_title']?.toString() ?? '🎁 ماہانہ انعامی قرعہ اندازی و زیرو ایڈوانس';
  String get prizeDesc => policies['prize_desc']?.toString() ?? '';

  ShopShowcaseController() {
    initData();
  }

  Future<void> initData() async {
    isLoading = true;
    notifyListeners();

    config = await ShowcaseConfigService.loadShowcaseConfig();
    availablePlansCount = await PlanCounterService.getAvailablePlansCount();
    quotaMetrics = await LiveQuotaService.getMonthlyQuotaMetrics();
    slots = SlotsFeedService.getLiveSlotsFeed(availablePlansCount);

    if (config['media_showcase'] is List) {
      mediaList = (config['media_showcase'] as List)
          .whereType<Map>()
          .map((m) => Map<String, dynamic>.from(m))
          .toList();
    }

    isLoading = false;
    notifyListeners();
  }

  void toggleAudio() {
    _audioService.togglePlayState();
    notifyListeners();
  }

  String getShareContent() {
    return ShowcaseShareService.generateShareText(
      shopName: shopName,
      patronName: patronName,
      address: address,
      whatsapp: whatsapp,
      plansCount: availablePlansCount,
    );
  }

  @override
  void dispose() {
    _audioService.stop();
    super.dispose();
  }
}