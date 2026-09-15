import 'package:flutter/material.dart';
import 'device_plan_detail_controller.dart';
import 'components/detail_app_bar_ui.dart';
import 'components/hero_image_swiper_ui.dart';
import 'components/device_spec_pills_ui.dart';
import 'components/vip_28_promotional_banner_ui.dart';
import 'components/guarantee_filter_bar_ui.dart';
import 'components/advance_option_filter_bar_ui.dart';
import 'components/duration_seven_filter_bar_ui.dart';
import 'components/custom_advance_input_box_ui.dart';
import 'components/plan_sorting_toolbar_ui.dart';
import 'components/bill_style_schedule_header_ui.dart';
import 'components/individual_plan_row_ui.dart';
import 'components/order_receipt_sheet/order_receipt_sheet.dart';

class DevicePlanDetailPage extends StatefulWidget {
  final Map<String, dynamic> device;
  final String? customerPhone;

  const DevicePlanDetailPage({
    super.key,
    required this.device,
    this.customerPhone,
  });

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
        (widget.device['minAdvance'] as int?) ??
        5000;
    _controller.init(initAdv);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int baseValue = (widget.device['baseValue'] as int?) ?? 50000;
    final int minAdvReq = (widget.device['minAdvanceRequired'] as int?) ??
        (widget.device['minAdvance'] as int?) ??
        5000;
    final List<String> images = (widget.device['images'] as List?)?.cast<String>() ?? [];
    
    // 🎯 چیک کریں کہ کیا یہ کسٹمر کا دستی تخمینہ ہے
    final bool isCustomEstimate = widget.device['isCustomEstimate'] == true || images.isEmpty;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final plans = _controller.calculate28Plans(baseValue, minAdvReq);

          return Scaffold(
            backgroundColor: const Color(0xFFF1F5F9),
            appBar: DetailAppBarUi(
              title: widget.device['name'] ?? 'موبائل پلان',
              subtitle: 'نایاب قسط پوائنٹ • 28 سمارٹ اقساطی پیکجز',
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🌟 1. ٹاپ کارڈ: لائیو ڈیوائس بمقابلہ کسٹم تخمینہ
                  if (!isCustomEstimate)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Column(
                        children: [
                          HeroImageSwiperUi(images: images),
                          const Divider(height: 1, color: Color(0xFFE2E8F0)),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.device['name'] ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFECFDF5),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'صرف آسان اقساط پر دستیاب',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF059669),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                DeviceSpecPillsUi(
                                  ramRom: widget.device['ramRom'] ?? '',
                                  condition: widget.device['condition'] ?? '',
                                  warranty: widget.device['warranty'] ?? '12 ماہ آفیشل وارنٹی',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    // 🌟 دستی تخمینہ کے لیے کسٹم برانڈڈ ہیڈر کارڈ
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF334155), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF059669).withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.calculate_rounded, color: Color(0xFF34D399), size: 20),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.device['name'] ?? 'اپنی مرضی کی قیمت کا تخمینہ',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'نایاب قسط پوائنٹ • کسٹم ریٹ کیلکولیٹر',
                                      style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 18, color: Color(0xFF334155)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'تخمینہ رقم: Rs. $baseValue',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFDE68A),
                                ),
                              ),
                              Text(
                                minAdvReq > 0 ? 'ایڈوانس: Rs. $minAdvReq' : 'بغیر ایڈوانس پلان',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF34D399),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 14),
                  const Vip28PromotionalBannerUi(),
                  const SizedBox(height: 10),

                  // 🌟 2. فلٹرز اور 28 پلانز کا مکمل نظام (بالکل پہلے کی طرح برقرار)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ضمانت اور مدت چھانٹیں (تمام فلٹرز آن ہونے پر 28 پیکجز نظر آئیں گے):',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                        ),
                        const SizedBox(height: 8),
                        GuaranteeFilterBarUi(
                          selectedFilter: _controller.selectedGuaranteeFilter,
                          onSelect: _controller.setGuaranteeFilter,
                        ),
                        const SizedBox(height: 6),
                        AdvanceOptionFilterBarUi(
                          selectedFilter: _controller.selectedAdvanceFilter,
                          onSelect: _controller.setAdvanceFilter,
                        ),
                        const SizedBox(height: 6),
                        DurationSevenFilterBarUi(
                          selectedDuration: _controller.selectedDuration,
                          onSelect: _controller.setDuration,
                        ),
                        const Divider(height: 16, color: Color(0xFFE2E8F0)),
                        CustomAdvanceInputBoxUi(
                          minAdvanceRequired: minAdvReq,
                          controller: _controller.customAdvanceCtrl,
                          onChanged: _controller.updateCustomAdvance,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  PlanSortingToolbarUi(
                    activeSort: _controller.activeSort,
                    onSortChanged: _controller.setSort,
                  ),
                  const SizedBox(height: 10),
                  BillStyleScheduleHeaderUi(count: plans.length),
                  const SizedBox(height: 8),
                  ...plans.map((plan) {
                    return IndividualPlanRowUi(
                      plan: plan,
                      onOrderTap: () {
                        final schedule = _controller.generateSchedule(plan['months'], plan['monthly']);
                        OrderReceiptSheet.show(
                          context,
                          plan: plan,
                          deviceName: widget.device['name'] ?? '',
                          customerPhone: widget.customerPhone,
                          installmentSchedule: schedule,
                        );
                      },
                    );
                  }),
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