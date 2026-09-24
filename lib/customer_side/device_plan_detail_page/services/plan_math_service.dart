import 'calculator_config_model.dart';

class PlanMathService {
  /// رقم کو طے شدہ یونٹ (مثلاً 100) کے اگلے ملٹیپل پر راؤنڈ (Ceil) کرنا
  static int ceilValue(num value, int roundToNearest) {
    if (roundToNearest <= 0) return value.ceil();
    final double remainder = (value % roundToNearest).toDouble();
    if (remainder == 0) return value.toInt();
    return (value + (roundToNearest - remainder)).toInt();
  }

  /// 1. بنیادی رقم (Principal) نکالنا
  static int calculatePrincipal({
    required int baseValue,
    required CalculatorConfigModel config,
  }) {
    if (config.addProcessingFeeToPrincipal) {
      return baseValue + config.processingFee;
    }
    return baseValue;
  }

  /// 2. کل معاہدہ رقم (Total Contract Price) باقاعدہ کمپاؤنڈنگ مع سیلنگ کے ساتھ
  static int calculateTotalContractPrice({
    required int principal,
    required int months,
    required bool isCheque,
    required CalculatorConfigModel config,
  }) {
    final int baseDuration = config.allowedDurations.isNotEmpty
        ? config.allowedDurations.first
        : 6;
    final double baseRate =
        isCheque ? config.profitWithCheck : config.profitWithoutCheck;
    final int extraMonths = (months - baseDuration) > 0 ? (months - baseDuration) : 0;

    double calculatedTotal = 0.0;

    if (!config.isCompoundingProfit) {
      // سادہ ریٹ: مثلاً 25% + (1 * 5%) = 30%
      final double totalRate = baseRate + (extraMonths * config.perMonthIncrement);
      calculatedTotal = principal * (1.0 + totalRate);
    } else {
      // کمپاؤنڈنگ: پہلے بیس مدت (مثلاً 6 ماہ) کا بل نکالیں
      double runningTotal = principal * (1.0 + baseRate);
      // ہر اضافی ماہ پر پچھلے کل بل پر سیدھا 5% اضافہ
      for (int i = 0; i < extraMonths; i++) {
        runningTotal = runningTotal * (1.0 + config.perMonthIncrement);
      }
      calculatedTotal = runningTotal;
    }

    if (!config.addProcessingFeeToPrincipal && config.processingFee > 0) {
      calculatedTotal += config.processingFee;
    }

    return ceilValue(calculatedTotal, config.roundToNearest);
  }

  /// 3. کم از کم ایڈوانس (80% فارمولا)
  static int calculateMinAdvance({
    required int totalContractPrice,
    required int months,
    required CalculatorConfigModel config,
  }) {
    if (months <= 0) return 0;
    final double theoreticalEmi = totalContractPrice / months;
    final double rawMinAdv = theoreticalEmi * config.advancePercentage;
    return ceilValue(rawMinAdv, config.roundToNearest);
  }

  /// 4. بقایا (m - 1) مہینوں کی ماہانہ قسط
  static int calculateMonthlyEmi({
    required int totalContractPrice,
    required int advancePaid,
    required int months,
    required CalculatorConfigModel config,
  }) {
    final int remainingInstallments = (months - 1) > 0 ? (months - 1) : 1;
    final int balance = totalContractPrice - advancePaid;
    if (balance <= 0) return 0;

    final double rawMonthly = balance / remainingInstallments;
    return ceilValue(rawMonthly, config.roundToNearest);
  }
}