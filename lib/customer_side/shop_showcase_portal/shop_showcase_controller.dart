import 'package:flutter/material.dart';
import 'services/showcase_config_service.dart';
import 'services/plan_counter_service.dart';
import 'services/live_quota_service.dart';
import 'services/slots_feed_service.dart';
import 'services/showcase_audio_service.dart';
import 'services/showcase_share_service.dart';

class ShopShowcaseController extends ChangeNotifier {
  final ShowcaseAudioService _audioService = ShowcaseAudioService();

  bool isLoading = true;
  Map<String, dynamic> config = {};
  int availablePlansCount = 36;
  Map<String, int> quotaMetrics = {'total': 10, 'delivered': 5, 'remaining': 5};
  List<ShowcaseSlotItem> slots = [];
  List<Map<String, dynamic>> mediaList = [];

  bool get isAudioPlaying => _audioService.isPlaying;

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
    final shop = (config['shop_info'] as Map?) ?? {};
    return ShowcaseShareService.generateShareText(
      shopName: shop['shop_name']?.toString() ?? 'نایاب قسط پوائنٹ',
      patronName: shop['patron_name']?.toString() ?? 'حافظ محمد صابر مونڈ',
      address: shop['address']?.toString() ?? 'ہیڈ اسلام روڈ، نزد گورنمنٹ بوائز ہائی اسکول، قائم پور',
      whatsapp: shop['whatsapp']?.toString() ?? '0323 1988351',
      plansCount: availablePlansCount,
    );
  }

  @override
  void dispose() {
    _audioService.stop();
    super.dispose();
  }
}