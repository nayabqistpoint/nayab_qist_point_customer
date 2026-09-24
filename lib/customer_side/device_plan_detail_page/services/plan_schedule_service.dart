import 'calculator_config_model.dart';

class PlanScheduleService {
  static const List<String> urduMonths = [
    '',
    'جنوری',
    'فروری',
    'مارچ',
    'اپریل',
    'مئی',
    'جون',
    'جولائی',
    'اگست',
    'ستمبر',
    'اکتوبر',
    'نومبر',
    'دسمبر',
  ];

  /// پوری m اقساط کا شیڈول تیار کرنا (پہلی قسط موقع پر + بقیہ m-1 اقساط)
  static List<Map<String, dynamic>> generateSchedule({
    required int totalMonths,
    required int monthlyAmount,
    required int advancePaid,
    required CalculatorConfigModel config,
    DateTime? requestDate,
  }) {
    final List<Map<String, dynamic>> schedule = [];
    final DateTime now = requestDate ?? DateTime.now();
    final int dueDay = config.installmentDueDay > 0 ? config.installmentDueDay : 5;
    final int graceDays = config.gracePeriodDays > 0 ? config.gracePeriodDays : 15;

    // پہلی قسط: موقع پر ادائیگی (درخواست کی موجودہ تاریخ)
    final String todayFormatted =
        '${now.day.toString().padLeft(2, '0')} ${urduMonths[now.month]} ${now.year}';
    
    schedule.add({
      'no': 1,
      'dueDate': '$todayFormatted (موقع پر / ایڈوانس)',
      'amount': advancePaid,
      'status': advancePaid > 0 ? 'PAID_ADVANCE' : 'ZERO_ADVANCE',
    });

    // اگلی قسطوں کے لیے 5 تاریخ کا تعین
    DateTime nextDue = DateTime(now.year, now.month, dueDay);
    if (nextDue.isBefore(now)) {
      nextDue = DateTime(now.year, now.month + 1, dueDay);
    }

    final int daysLeft = nextDue.difference(now).inDays;
    DateTime firstDueDate = nextDue;
    if (daysLeft < graceDays) {
      firstDueDate = DateTime(nextDue.year, nextDue.month + 1, dueDay);
    }

    // باقی ماندہ (totalMonths - 1) اقساط کا اندراج
    final int remainingCount = (totalMonths - 1) > 0 ? (totalMonths - 1) : 1;

    for (int i = 0; i < remainingCount; i++) {
      final DateTime installmentDate = DateTime(
        firstDueDate.year,
        firstDueDate.month + i,
        dueDay,
      );
      final String formattedDate =
          '${installmentDate.day.toString().padLeft(2, '0')} ${urduMonths[installmentDate.month]} ${installmentDate.year}';

      schedule.add({
        'no': i + 2, // نمبر 2 سے شروع ہو کر totalMonths تک جائے گا
        'dueDate': formattedDate,
        'amount': monthlyAmount,
        'status': 'DUE',
      });
    }

    return schedule;
  }
}