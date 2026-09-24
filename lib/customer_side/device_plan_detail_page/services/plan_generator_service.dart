import 'calculator_config_model.dart';
import 'plan_math_service.dart';

class PlanGeneratorService {
  static List<Map<String, dynamic>> generateAllPlans({
    required int baseValue,
    required int userCustomAdvance,
    required CalculatorConfigModel config,
  }) {
    final List<Map<String, dynamic>> plans = [];
    final int principal = PlanMathService.calculatePrincipal(
      baseValue: baseValue,
      config: config,
    );

    for (final int m in config.allowedDurations) {
      // 1. بینک چیک آپشن
      final int chequeTotal = PlanMathService.calculateTotalContractPrice(
        principal: principal,
        months: m,
        isCheque: true,
        config: config,
      );
      final int chequeMinAdv = PlanMathService.calculateMinAdvance(
        totalContractPrice: chequeTotal,
        months: m,
        config: config,
      );
      final int effectiveChequeAdv = userCustomAdvance > 0
          ? (userCustomAdvance > chequeTotal ? chequeTotal : userCustomAdvance)
          : chequeMinAdv;

      // چیک مع ایڈوانس
      plans.add({
        'months': m,
        'guarantee': 'BANK_CHEQUE',
        'hasAdvance': true,
        'advance': effectiveChequeAdv,
        'monthly': PlanMathService.calculateMonthlyEmi(
          totalContractPrice: chequeTotal,
          advancePaid: effectiveChequeAdv,
          months: m,
          config: config,
        ),
        'totalContract': chequeTotal,
        'minAdvanceRequired': chequeMinAdv,
      });

      // چیک بغیر ایڈوانس (Zero Advance)
      plans.add({
        'months': m,
        'guarantee': 'BANK_CHEQUE',
        'hasAdvance': false,
        'advance': 0,
        'monthly': PlanMathService.calculateMonthlyEmi(
          totalContractPrice: chequeTotal,
          advancePaid: 0,
          months: m,
          config: config,
        ),
        'totalContract': chequeTotal,
        'minAdvanceRequired': chequeMinAdv,
      });

      // 2. اشٹام پرنوٹ آپشن
      final int stampTotal = PlanMathService.calculateTotalContractPrice(
        principal: principal,
        months: m,
        isCheque: false,
        config: config,
      );
      final int stampMinAdv = PlanMathService.calculateMinAdvance(
        totalContractPrice: stampTotal,
        months: m,
        config: config,
      );
      final int effectiveStampAdv = userCustomAdvance > 0
          ? (userCustomAdvance > stampTotal ? stampTotal : userCustomAdvance)
          : stampMinAdv;

      // اشٹام مع ایڈوانس
      plans.add({
        'months': m,
        'guarantee': 'LEGAL_STAMP',
        'hasAdvance': true,
        'advance': effectiveStampAdv,
        'monthly': PlanMathService.calculateMonthlyEmi(
          totalContractPrice: stampTotal,
          advancePaid: effectiveStampAdv,
          months: m,
          config: config,
        ),
        'totalContract': stampTotal,
        'minAdvanceRequired': stampMinAdv,
      });

      // اشٹام بغیر ایڈوانس (Zero Advance)
      plans.add({
        'months': m,
        'guarantee': 'LEGAL_STAMP',
        'hasAdvance': false,
        'advance': 0,
        'monthly': PlanMathService.calculateMonthlyEmi(
          totalContractPrice: stampTotal,
          advancePaid: 0,
          months: m,
          config: config,
        ),
        'totalContract': stampTotal,
        'minAdvanceRequired': stampMinAdv,
      });
    }

    return plans;
  }
}