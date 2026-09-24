import 'package:flutter/material.dart';
import '../device_plan_detail_controller.dart';
import 'guarantee_filter_bar_ui.dart';
import 'advance_option_filter_bar_ui.dart';
import 'duration_seven_filter_bar_ui.dart';
import 'custom_advance_input_box_ui.dart';

class PlanFilterSectionCardUi extends StatelessWidget {
  final DevicePlanDetailController controller;
  final int totalPossiblePlans;
  final int chequeCount;
  final int stampCount;
  final int zeroAdvCount;
  final int withAdvCount;
  final int calculatedMinAdv;

  const PlanFilterSectionCardUi({
    super.key,
    required this.controller,
    required this.totalPossiblePlans,
    required this.chequeCount,
    required this.stampCount,
    required this.zeroAdvCount,
    required this.withAdvCount,
    required this.calculatedMinAdv,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'ضمانت اور مدت چھانٹیں (تمام فلٹرز آن ہونے پر تمام پیکجز نظر آئیں گے):',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),
          GuaranteeFilterBarUi(
            selectedFilter: controller.selectedGuaranteeFilter,
            totalCount: totalPossiblePlans,
            chequeCount: chequeCount,
            stampCount: stampCount,
            onSelect: controller.setGuaranteeFilter,
          ),
          const SizedBox(height: 6),
          AdvanceOptionFilterBarUi(
            selectedFilter: controller.selectedAdvanceFilter,
            totalCount: totalPossiblePlans,
            zeroAdvCount: zeroAdvCount,
            withAdvCount: withAdvCount,
            onSelect: controller.setAdvanceFilter,
          ),
          const SizedBox(height: 6),
          DurationSevenFilterBarUi(
            selectedDuration: controller.selectedDuration,
            allowedDurations: controller.config.allowedDurations,
            onSelect: controller.setDuration,
          ),
          const Divider(height: 16, color: Color(0xFFE2E8F0)),
          CustomAdvanceInputBoxUi(
            minAdvanceRequired: calculatedMinAdv,
            controller: controller.customAdvanceCtrl,
            onChanged: controller.updateCustomAdvance,
          ),
        ],
      ),
    );
  }
}