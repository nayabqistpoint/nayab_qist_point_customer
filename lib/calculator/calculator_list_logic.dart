import 'package:nayab_qist_point_customer/calculator/app_config_service.dart';

class CalculatorListLogic {
  /// کل رقم، پرافٹ اور لائیو پروسیسنگ فیس کا حساب
  static double getTotalWithProfit({
    required double totalAmount,
    required int months,
    required bool hasSecurityCheck,
  }) {
    double baseProfit = hasSecurityCheck
        ? AppConfigService.profitWithCheck
        : AppConfigService.profitWithoutCheck;

    double profitPercentage = baseProfit + ((months - 6) * AppConfigService.perMonthIncrement);
    double totalWithProfit = totalAmount + (totalAmount * profitPercentage);

    // 🟢 پروسیسنگ فیس کا اضافہ
    return totalWithProfit + AppConfigService.processingFee;
  }

  /// بغیر ایڈوانس قسط کا حساب
  static double calculateInstallmentWithoutAdvance({
    required double totalAmount,
    required int months,
    required bool hasSecurityCheck,
  }) {
    double total = getTotalWithProfit(
      totalAmount: totalAmount,
      months: months,
      hasSecurityCheck: hasSecurityCheck,
    );
    return total / months;
  }

  /// کم از کم لازمی ایڈوانس کا حساب
  static double getMinimumRequiredAdvance({
    required double totalAmount,
    required bool hasSecurityCheck,
  }) {
    double base6MonthInstallment = calculateInstallmentWithoutAdvance(
      totalAmount: totalAmount,
      months: 6,
      hasSecurityCheck: hasSecurityCheck,
    );
    return base6MonthInstallment * 0.8;
  }

  /// ایڈوانس کے ساتھ قسط کا حساب
  static double calculateInstallmentWithAdvance({
    required double totalAmount,
    required double advanceAmount,
    required int months,
    required bool hasSecurityCheck,
  }) {
    double total = getTotalWithProfit(
      totalAmount: totalAmount,
      months: months,
      hasSecurityCheck: hasSecurityCheck,
    );

    double minAdvRequired = getMinimumRequiredAdvance(
      totalAmount: totalAmount,
      hasSecurityCheck: hasSecurityCheck,
    );

    double effectiveAdvance = (advanceAmount > 0 && advanceAmount >= minAdvRequired)
        ? advanceAmount
        : minAdvRequired;

    return (total - effectiveAdvance) / (months - 1);
  }

  /// تمام 6 سے 12 ماہ کے پیکجز کی فہرست جنریٹ کرنا
  static List<Map<String, dynamic>> generateAllPackages({
    required double totalAmount,
    required double advanceAmount,
    required bool hasSecurityCheck,
  }) {
    List<Map<String, dynamic>> results = [];
    if (totalAmount <= 0) return results;

    for (int i = 6; i <= 12; i++) {
      double total = getTotalWithProfit(
        totalAmount: totalAmount,
        months: i,
        hasSecurityCheck: hasSecurityCheck,
      );

      double installmentWithout = calculateInstallmentWithoutAdvance(
        totalAmount: totalAmount,
        months: i,
        hasSecurityCheck: hasSecurityCheck,
      );

      double installmentWith = calculateInstallmentWithAdvance(
        totalAmount: totalAmount,
        advanceAmount: advanceAmount,
        months: i,
        hasSecurityCheck: hasSecurityCheck,
      );

      double minAdv = getMinimumRequiredAdvance(
        totalAmount: totalAmount,
        hasSecurityCheck: hasSecurityCheck,
      );

      double actualAdvanceToDisplay =
          (advanceAmount > 0 && advanceAmount >= minAdv) ? advanceAmount : minAdv;

      // A Package (Advance)
      results.add({
        "packageName": "${i}A",
        "title": "$i ماہ (ایڈوانس کے ساتھ)",
        "months": "$i ماہ",
        "total": total.toStringAsFixed(0),
        "installment": installmentWith.toStringAsFixed(0),
        "advance": actualAdvanceToDisplay.toStringAsFixed(0),
        "isAdvance": true,
      });

      // B Package (Without Advance)
      results.add({
        "packageName": "${i}B",
        "title": "$i ماہ (بغیر ایڈوانس)",
        "months": "$i ماہ",
        "total": total.toStringAsFixed(0),
        "installment": installmentWithout.toStringAsFixed(0),
        "advance": "0",
        "isAdvance": false,
      });
    }

    return results;
  }
}