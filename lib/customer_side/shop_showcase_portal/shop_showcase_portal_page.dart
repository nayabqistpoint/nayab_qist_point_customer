import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/shop_showcase_args.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/shop_showcase_controller.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/components/shop_showcase_app_bar_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/components/patron_hero_card_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/components/audio_announcement_bar_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/components/live_metrics_ribbon_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/components/privacy_shield_card_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/components/prize_draw_card_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/components/products_wings_card_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/components/large_slots_schedule_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/components/media_showcase_row_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/components/share_notice_card_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/shop_showcase_portal/components/contact_location_card_ui.dart';

class ShopShowcasePortalPage extends StatefulWidget {
  final ShopShowcaseArgs? args;

  const ShopShowcasePortalPage({super.key, this.args});

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
            body: Center(child: CircularProgressIndicator(color: Color(0xFF0D9488))),
          );
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: ShopShowcaseAppBarUi(
              shopTitle: controller.shopName,
              shopSubtitle: 'قائم پور، تحصیل حاصل پور',
            ),
            body: ListView(
              padding: const EdgeInsets.all(14),
              physics: const BouncingScrollPhysics(),
              children: [
                PatronHeroCardUi(
                  patronName: controller.patronName,
                  patronRole: controller.patronRole,
                  shopName: controller.shopName,
                  address: controller.address,
                ),
                const SizedBox(height: 14),
                AudioAnnouncementBarUi(
                  isPlaying: controller.isAudioPlaying,
                  patronName: controller.patronName,
                  durationText: controller.audioDurationText,
                  onTogglePlay: controller.toggleAudio,
                ),
                const SizedBox(height: 14),
                LiveMetricsRibbonUi(
                  totalQuota: controller.quotaMetrics['total'] ?? 10,
                  deliveredCount: controller.quotaMetrics['delivered'] ?? 6,
                ),
                const SizedBox(height: 14),
                PrivacyShieldCardUi(
                  title: controller.privacyTitle,
                  description: controller.privacyDesc,
                ),
                const SizedBox(height: 14),
                PrizeDrawCardUi(
                  title: controller.prizeTitle,
                  description: controller.prizeDesc,
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
                ContactLocationCardUi(whatsappNumber: controller.whatsapp),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}