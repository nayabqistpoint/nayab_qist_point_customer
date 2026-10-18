import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/device_plan_detail_args.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/device_plan_detail_controller.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/components/detail_app_bar_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/components/stock_device_hero_card_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/components/custom_estimate_hero_card_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/components/vip_28_promotional_banner_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/components/plan_filter_section_card_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/components/plan_sorting_toolbar_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/components/bill_style_schedule_header_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/components/individual_plan_row_ui.dart';

class DevicePlanDetailPage extends StatefulWidget {
  final DevicePlanDetailArgs? args;

  const DevicePlanDetailPage({super.key, this.args});

  @override
  State<DevicePlanDetailPage> createState() => _DevicePlanDetailPageState();
}

class _DevicePlanDetailPageState extends State<DevicePlanDetailPage> {
  late final DevicePlanDetailController _controller;
  Map<String, dynamic> _device = const {};
  String? _customerPhone;

  @override
  void initState() {
    super.initState();
    _controller = DevicePlanDetailController();
    if (widget.args != null) {
      _device = widget.args!.device;
      _customerPhone = widget.args!.customerPhone;
      _initAdvance();
    }
  }

  void _initAdvance() {
    final int initAdv = (_device['userCustomAdvance'] as int?) ??
        (_device['minAdvanceRequired'] as int?) ??
        (_device['minAdvance'] as int?) ?? 0;
    _controller.init(initAdv);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_device.isEmpty) {
      final rawArgs = ModalRoute.of(context)?.settings.arguments;
      if (rawArgs is DevicePlanDetailArgs) {
        _device = rawArgs.device;
        _customerPhone = rawArgs.customerPhone;
        _initAdvance();
      } else if (rawArgs is Map<String, dynamic>) {
        final parsed = DevicePlanDetailArgs.fromMap(rawArgs);
        _device = parsed.device;
        _customerPhone = parsed.customerPhone;
        _initAdvance();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int baseValue = (_device['baseValue'] as int?) ?? 0;
    final List<String> images = (_device['images'] as List?)?.cast<String>() ?? [];
    final bool isCustomEstimate = _device['isCustomEstimate'] == true;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final rawPlans = _controller.getAllRawPlans(baseValue);
          final plans = _controller.getFilteredPlans(rawPlans);
          final int calculatedMinAdv = _controller.getDynamicMinAdvance(baseValue);
          final int displayedAdv = _controller.userCustomAdvance > 0
              ? _controller.userCustomAdvance
              : calculatedMinAdv;

          return Scaffold(
            backgroundColor: const Color(0xFFF1F5F9),
            appBar: DetailAppBarUi(
              title: _device['name'] ?? 'موبائل پلان',
              subtitle: 'نایاب قسط پوائنٹ • ${rawPlans.length} سمارٹ اقساطی پیکجز',
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isCustomEstimate)
                    StockDeviceHeroCardUi(device: _device, images: images)
                  else
                    CustomEstimateHeroCardUi(
                      title: _device['name'] ?? 'اپنی مرضی کی قیمت کا تخمینہ',
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
                  PlanSortingToolbarUi(
                    activeSort: _controller.activeSort,
                    onSortChanged: _controller.setSort,
                  ),
                  const SizedBox(height: 10),
                  BillStyleScheduleHeaderUi(count: plans.length),
                  const SizedBox(height: 8),
                  ...plans.map(
                    (plan) => IndividualPlanRowUi(
                      plan: plan,
                      onOrderTap: () => _controller.openOrderReceiptPage(
                        context: context,
                        plan: plan,
                        device: _device,
                        customerPhone: _customerPhone,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}