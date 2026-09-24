import 'package:flutter/material.dart';
import 'services/calculator_config_model.dart';
import 'services/calculator_config_service.dart';
import 'services/plan_generator_service.dart';
import 'services/plan_filter_sort_service.dart';
import 'services/plan_schedule_service.dart';
import 'services/plan_math_service.dart';

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

  /// بنیادی تخمینہ کے لیے متحرک کم از کم ایڈوانس نکالنا
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

  /// تمام ممکنہ غیر فلٹر شدہ پلانز (سنگل سورس آف ٹروتھ)
  List<Map<String, dynamic>> getAllRawPlans(int baseValue) {
    return PlanGeneratorService.generateAllPlans(
      baseValue: baseValue,
      userCustomAdvance: userCustomAdvance,
      config: config,
    );
  }

  /// سکرین پر ظاہر ہونے والے فلٹر شدہ پلانز
  List<Map<String, dynamic>> getFilteredPlans(List<Map<String, dynamic>> allPlans) {
    return PlanFilterSortService.filterAndSort(
      allPlans: allPlans,
      guaranteeFilter: selectedGuaranteeFilter,
      advanceFilter: selectedAdvanceFilter,
      durationFilter: selectedDuration,
      sortKey: activeSort,
    );
  }

  /// پورا شیڈول جنریٹ کرنا
  List<Map<String, dynamic>> generateSchedule({
    required int months,
    required int monthlyAmount,
    required int advancePaid,
  }) {
    return PlanScheduleService.generateSchedule(
      totalMonths: months,
      monthlyAmount: monthlyAmount,
      advancePaid: advancePaid,
      config: config,
    );
  }

  @override
  void dispose() {
    customAdvanceCtrl.dispose();
    super.dispose();
  }
}