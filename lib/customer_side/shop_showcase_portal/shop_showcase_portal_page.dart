import 'package:flutter/material.dart';
import 'shop_showcase_controller.dart';
import 'components/patron_hero_card_ui.dart';
import 'components/audio_announcement_bar_ui.dart';
import 'components/live_metrics_ribbon_ui.dart';
import 'components/privacy_shield_card_ui.dart';
import 'components/prize_draw_card_ui.dart';
import 'components/products_wings_card_ui.dart';
import 'components/large_slots_schedule_ui.dart';
import 'components/media_showcase_row_ui.dart';
import 'components/share_notice_card_ui.dart';
import 'components/contact_location_card_ui.dart';

class ShopShowcasePortalPage extends StatefulWidget {
  const ShopShowcasePortalPage({super.key});

  @override
  State<ShopShowcasePortalPage> createState() => _ShopShowcasePortalPageState();
}

class _ShopShowcasePortalPageState extends State<ShopShowcasePortalPage> {
  late final ShopShowcaseController controller;

  @override
  void initState() {
    super.initState();
    controller = ShopShowcaseController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (controller.isLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFFF8FAFC),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF0D9488)),
            ),
          );
        }

        final config = controller.config;
        final shopInfo = (config['shop_info'] as Map?) ?? {};
        final audioInfo = (config['audio_announcement'] as Map?) ?? {};
        final policies = (config['policies'] as Map?) ?? {};

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              elevation: 2,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shopInfo['shop_name']?.toString() ?? 'نایاب قسط پوائنٹ - لائیو پورٹل',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const Text(
                    'قائم پور، تحصیل حاصل پور',
                    style: TextStyle(
                      color: Color(0xFFFDE68A),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF14B8A6), width: 0.8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(radius: 3.5, backgroundColor: Color(0xFF2DD4BF)),
                      SizedBox(width: 5),
                      Text(
                        'لائیو کاؤنٹر',
                        style: TextStyle(color: Color(0xFF5EEAD4), fontSize: 10.5, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(14),
              physics: const BouncingScrollPhysics(),
              children: [
                PatronHeroCardUi(
                  patronName: shopInfo['patron_name']?.toString() ?? 'حافظ محمد صابر مونڈ',
                  patronRole: shopInfo['patron_role']?.toString() ?? 'پروپرائیٹر و نگرانِ اعلیٰ',
                  shopName: shopInfo['shop_name']?.toString() ?? 'نایاب قسط پوائنٹ',
                  address: shopInfo['address']?.toString() ?? 'ہیڈ اسلام روڈ، نزد گورنمنٹ بوائز ہائی اسکول، قائم پور',
                ),
                const SizedBox(height: 14),
                AudioAnnouncementBarUi(
                  isPlaying: controller.isAudioPlaying,
                  patronName: shopInfo['patron_name']?.toString() ?? 'حافظ محمد صابر مونڈ',
                  durationText: audioInfo['duration_text']?.toString() ?? '0:42 سیکنڈ',
                  onTogglePlay: controller.toggleAudio,
                ),
                const SizedBox(height: 14),
                LiveMetricsRibbonUi(
                  totalQuota: controller.quotaMetrics['total'] ?? 10,
                  deliveredCount: controller.quotaMetrics['delivered'] ?? 5,
                ),
                const SizedBox(height: 14),
                PrivacyShieldCardUi(
                  title: policies['privacy_title']?.toString() ?? '🛡️ کسٹمر کی عزت و رازداری کی 100% ضمانت',
                  description: policies['privacy_desc']?.toString() ?? '',
                ),
                const SizedBox(height: 14),
                PrizeDrawCardUi(
                  title: policies['prize_title']?.toString() ?? '🎁 ماہانہ انعامی قرعہ اندازی و زیرو ایڈوانس',
                  description: policies['prize_desc']?.toString() ?? '',
                ),
                const SizedBox(height: 16),
                ProductsWingsCardUi(plansCount: controller.availablePlansCount),
                const SizedBox(height: 16),
                LargeSlotsScheduleUi(slots: controller.slots),
                const SizedBox(height: 16),
                MediaShowcaseRowUi(mediaList: controller.mediaList),
                const SizedBox(height: 16),
                ShareNoticeCardUi(
                  onSharePressed: () {
                    final text = controller.getShareContent();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('شیئرنگ مواد تیار ہو گیا: $text')),
                    );
                  },
                ),
                const SizedBox(height: 14),
                ContactLocationCardUi(
                  whatsappNumber: shopInfo['whatsapp']?.toString() ?? '0323 1988351',
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}