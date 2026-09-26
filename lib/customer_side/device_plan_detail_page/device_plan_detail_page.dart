import 'package:flutter/material.dart';
import 'device_plan_detail_controller.dart';
import 'components/detail_app_bar_ui.dart';
import 'components/stock_device_hero_card_ui.dart';
import 'components/custom_estimate_hero_card_ui.dart';
import 'components/vip_28_promotional_banner_ui.dart';
import 'components/plan_filter_section_card_ui.dart';
import 'components/plan_sorting_toolbar_ui.dart';
import 'components/bill_style_schedule_header_ui.dart';
import 'components/individual_plan_row_ui.dart';
import '../order_receipt_sheet/order_receipt_sheet.dart';

class DevicePlanDetailPage extends StatefulWidget {
  final Map<String, dynamic> device;
  final String? customerPhone;

  const DevicePlanDetailPage({super.key, required this.device, this.customerPhone});

  @override
  State<DevicePlanDetailPage> createState() => _DevicePlanDetailPageState();
}

class _DevicePlanDetailPageState extends State<DevicePlanDetailPage> {
  late final DevicePlanDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DevicePlanDetailController();
    final int initAdv = (widget.device['userCustomAdvance'] as int?) ??
        (widget.device['minAdvanceRequired'] as int?) ??
        (widget.device['minAdvance'] as int?) ?? 0;
    _controller.init(initAdv);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openOrderSheet(Map<String, dynamic> plan) {
    final schedule = _controller.generateSchedule(
      months: plan['months'],
      monthlyAmount: plan['monthly'],
      advancePaid: plan['advance'],
    );
    OrderReceiptSheet.show(
      context,
      plan: plan,
      deviceName: widget.device['name'] ?? '',
      customerPhone: widget.customerPhone,
      installmentSchedule: schedule,
      sourceMode: widget.device['isCustomEstimate'] == true ? 'CUSTOM_ESTIMATE' : 'STOCK',
      imeiNo: widget.device['imeiNo']?.toString() ?? widget.device['imei']?.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int baseValue = (widget.device['baseValue'] as int?) ?? 0;
    final List<String> images = (widget.device['images'] as List?)?.cast<String>() ?? [];
    final bool isCustomEstimate = widget.device['isCustomEstimate'] == true;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final rawPlans = _controller.getAllRawPlans(baseValue);
          final plans = _controller.getFilteredPlans(rawPlans);
          final int calculatedMinAdv = _controller.getDynamicMinAdvance(baseValue);
          final int displayedAdv = _controller.userCustomAdvance > 0 ? _controller.userCustomAdvance : calculatedMinAdv;

          return Scaffold(
            backgroundColor: const Color(0xFFF1F5F9),
            appBar: DetailAppBarUi(
              title: widget.device['name'] ?? 'موبائل پلان',
              subtitle: 'نایاب قسط پوائنٹ • ${rawPlans.length} سمارٹ اقساطی پیکجز',
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isCustomEstimate)
                    StockDeviceHeroCardUi(device: widget.device, images: images)
                  else
                    CustomEstimateHeroCardUi(
                      title: widget.device['name'] ?? 'اپنی مرضی کی قیمت کا تخمینہ',
                      baseValue: baseValue,
                      displayedAdvance: displayedAdv,
                    ),
                  const SizedBox(height: 14),
                  Vip28PromotionalBannerUi(
                    totalCount: rawPlans.length,
                    durationCount: _controller.config.allowedDurations.length,
                  ),
                  const SizedBox(height: 10),
                  PlanFilterSectionCardUi(
                    controller: _controller,
                    totalPossiblePlans: rawPlans.length,
                    chequeCount: rawPlans.where((p) => p['guarantee'] == 'BANK_CHEQUE').length,
                    stampCount: rawPlans.where((p) => p['guarantee'] == 'LEGAL_STAMP').length,
                    zeroAdvCount: rawPlans.where((p) => p['hasAdvance'] == false).length,
                    withAdvCount: rawPlans.where((p) => p['hasAdvance'] == true).length,
                    calculatedMinAdv: calculatedMinAdv,
                  ),
                  const SizedBox(height: 12),
                  PlanSortingToolbarUi(activeSort: _controller.activeSort, onSortChanged: _controller.setSort),
                  const SizedBox(height: 10),
                  BillStyleScheduleHeaderUi(count: plans.length),
                  const SizedBox(height: 8),
                  ...plans.map((plan) => IndividualPlanRowUi(plan: plan, onOrderTap: () => _openOrderSheet(plan))),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}