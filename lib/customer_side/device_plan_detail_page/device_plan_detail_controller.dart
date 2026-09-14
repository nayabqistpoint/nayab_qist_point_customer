import 'package:flutter/material.dart';

class DevicePlanDetailController extends ChangeNotifier {
  int selectedDuration = 0;
  String selectedGuaranteeFilter = 'ALL';
  String selectedAdvanceFilter = 'ALL';
  int userCustomAdvance = 0;

  // 🎯 نئی سارٹنگ کی حالت (DEFAULT, LOW_MONTHLY, SHORTEST_DURATION, LOWEST_TOTAL)
  String activeSort = 'DEFAULT';

  final TextEditingController customAdvanceCtrl = TextEditingController();

  void init(int initialAdvance) {
    userCustomAdvance = initialAdvance;
    customAdvanceCtrl.text = initialAdvance.toString();
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

  // 🎯 ترتیب بدلنے کا فنکشن
  void setSort(String sortKey) {
    activeSort = sortKey;
    notifyListeners();
  }

  List<Map<String, dynamic>> calculate28Plans(int baseValue, int minRequiredAdv) {
    final int effectiveAdvance = userCustomAdvance > 0 ? userCustomAdvance : minRequiredAdv;
    final List<int> durations = [6, 7, 8, 9, 10, 11, 12];
    List<Map<String, dynamic>> allPlans = [];

    for (var m in durations) {
      final totalWithProfitCheque = (baseValue * 1.25).toInt();
      final adv1 = effectiveAdvance;
      final monthly1 = ((totalWithProfitCheque - adv1) / m).toInt();

      allPlans.add({
        'months': m,
        'guarantee': 'BANK_CHEQUE',
        'hasAdvance': true,
        'advance': adv1,
        'monthly': monthly1,
      });

      allPlans.add({
        'months': m,
        'guarantee': 'BANK_CHEQUE',
        'hasAdvance': false,
        'advance': 0,
        'monthly': (totalWithProfitCheque / m).toInt(),
      });

      final totalWithProfitStamp = (baseValue * 1.35).toInt();
      final adv2 = effectiveAdvance;
      final monthly2 = ((totalWithProfitStamp - adv2) / m).toInt();

      allPlans.add({
        'months': m,
        'guarantee': 'LEGAL_STAMP',
        'hasAdvance': true,
        'advance': adv2,
        'monthly': monthly2,
      });

      allPlans.add({
        'months': m,
        'guarantee': 'LEGAL_STAMP',
        'hasAdvance': false,
        'advance': 0,
        'monthly': (totalWithProfitStamp / m).toInt(),
      });
    }

    final filtered = allPlans.where((p) {
      if (selectedGuaranteeFilter != 'ALL' && p['guarantee'] != selectedGuaranteeFilter) return false;
      if (selectedAdvanceFilter == 'WITH_ADV' && !p['hasAdvance']) return false;
      if (selectedAdvanceFilter == 'ZERO_ADV' && p['hasAdvance']) return false;
      if (selectedDuration != 0 && p['months'] != selectedDuration) return false;
      return true;
    }).toList();

    // 🎯 گاہک کی مرضی کے مطابق سمارٹ ترتیب (Sorting Engine)
    if (activeSort == 'LOW_MONTHLY') {
      // سب سے کم ماہانہ قسط سب سے اوپر
      filtered.sort((a, b) => (a['monthly'] as int).compareTo(b['monthly'] as int));
    } else if (activeSort == 'SHORTEST_DURATION') {
      // کم ترین مدت (تیز ترین اختتام) پہلے
      filtered.sort((a, b) => (a['months'] as int).compareTo(b['months'] as int));
    } else if (activeSort == 'LOWEST_TOTAL') {
      // ایڈوانس + تمام اقساط ملا کر سب سے سستا پیکج سب سے اوپر
      filtered.sort((a, b) {
        final totalA = (a['advance'] as int) + ((a['monthly'] as int) * (a['months'] as int));
        final totalB = (b['advance'] as int) + ((b['monthly'] as int) * (b['months'] as int));
        return totalA.compareTo(totalB);
      });
    }

    return filtered;
  }

  List<Map<String, dynamic>> generateSchedule(int months, int monthlyAmount) {
    final List<Map<String, dynamic>> schedule = [];
    final DateTime now = DateTime.now();

    DateTime nextFifth = DateTime(now.year, now.month, 5);
    if (nextFifth.isBefore(now)) {
      nextFifth = DateTime(now.year, now.month + 1, 5);
    }

    final int daysLeft = nextFifth.difference(now).inDays;
    DateTime firstDueDate = nextFifth;
    if (daysLeft < 15) {
      firstDueDate = DateTime(nextFifth.year, nextFifth.month + 1, 5);
    }

    final urduMonths = [
      '', 'جنوری', 'فروری', 'مارچ', 'اپریل', 'مئی', 'جون',
      'جولائی', 'اگست', 'ستمبر', 'اکتوبر', 'نومبر', 'دسمبر'
    ];

    for (int i = 0; i < months; i++) {
      final DateTime installmentDate = DateTime(firstDueDate.year, firstDueDate.month + i, 5);
      final String formattedDate = '05 ${urduMonths[installmentDate.month]} ${installmentDate.year}';

      schedule.add({
        'no': i + 1,
        'dueDate': formattedDate,
        'amount': monthlyAmount,
        'status': 'DUE',
      });
    }

    return schedule;
  }

  @override
  void dispose() {
    customAdvanceCtrl.dispose();
    super.dispose();
  }
}