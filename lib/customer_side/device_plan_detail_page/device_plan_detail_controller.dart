import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';
import 'package:nayab_qist_point_customer/customer_side/order_receipt_page/order_receipt_args.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/services/calculator_config_model.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/services/calculator_config_service.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/services/plan_generator_service.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/services/plan_filter_sort_service.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/services/plan_schedule_service.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/services/plan_math_service.dart';

class DevicePlanDetailController extends ChangeNotifier {
  final CalculatorConfigService _configService = CalculatorConfigService();
  int selectedDuration = 0;
  String selectedGuaranteeFilter = 'ALL';
  String selectedAdvanceFilter = 'ALL';
  int userCustomAdvance = 0;
  String activeSort = 'DEFAULT';
  final TextEditingController customAdvanceCtrl = TextEditingController();

  CalculatorConfigModel get config => _configService.getConfig();

  void init(int initialAdvance) {
    userCustomAdvance = initialAdvance;
    customAdvanceCtrl.text = initialAdvance > 0 ? initialAdvance.toString() : '';
  }

  void setGuaranteeFilter(String filter) {
    selectedGuaranteeFilter = filter;
    notifyListeners();
  }

  void setAdvanceFilter(String filter) {
    selectedAdvanceFilter = filter;
    notifyListeners();
  }

  void setDuration(int duration) {
    selectedDuration = duration;
    notifyListeners();
  }

  void updateCustomAdvance(int amount) {
    userCustomAdvance = amount;
    notifyListeners();
  }

  void setSort(String sortKey) {
    activeSort = sortKey;
    notifyListeners();
  }

  int getDynamicMinAdvance(int baseValue) {
    final currentConfig = config;
    final int principal = PlanMathService.calculatePrincipal(
      baseValue: baseValue,
      config: currentConfig,
    );
    final int minDuration = currentConfig.allowedDurations.isNotEmpty
        ? currentConfig.allowedDurations.first
        : 6;
    final int total = PlanMathService.calculateTotalContractPrice(
      principal: principal,
      months: minDuration,
      isCheque: true,
      config: currentConfig,
    );
    return PlanMathService.calculateMinAdvance(
      totalContractPrice: total,
      months: minDuration,
      config: currentConfig,
    );
  }

  List<Map<String, dynamic>> getAllRawPlans(int baseValue) {
    return PlanGeneratorService.generateAllPlans(
      baseValue: baseValue,
      userCustomAdvance: userCustomAdvance,
      config: config,
    );
  }

  List<Map<String, dynamic>> getFilteredPlans(List<Map<String, dynamic>> allPlans) {
    return PlanFilterSortService.filterAndSort(
      allPlans: allPlans,
      guaranteeFilter: selectedGuaranteeFilter,
      advanceFilter: selectedAdvanceFilter,
      durationFilter: selectedDuration,
      sortKey: activeSort,
    );
  }

  void openOrderReceiptPage({
    required BuildContext context,
    required Map<String, dynamic> plan,
    required Map<String, dynamic> device,
    required String? customerPhone,
  }) {
    final schedule = PlanScheduleService.generateSchedule(
      totalMonths: plan['months'],
      monthlyAmount: plan['monthly'],
      advancePaid: plan['advance'],
      config: config,
    );

    final args = OrderReceiptArgs(
      plan: plan,
      deviceName: device['name']?.toString() ?? 'موبائل فون',
      customerPhone: customerPhone,
      installmentSchedule: schedule,
      sourceMode: device['isCustomEstimate'] == true ? 'CUSTOM_ESTIMATE' : 'STOCK',
      imeiNo: device['imeiNo']?.toString() ?? device['imei']?.toString(),
    );

    Navigator.pushNamed(
      context,
      AppRoutes.orderReceipt,
      arguments: args,
    );
  }

  @override
  void dispose() {
    customAdvanceCtrl.dispose();
    super.dispose();
  }
}