class LedgerDateService {
  static const Map<String, int> _urduMonths = {
    'جنوری': 1, 'فروری': 2, 'مارچ': 3, 'اپریل': 4,
    'مئی': 5, 'جون': 6, 'جولائی': 7, 'اگست': 8,
    'ستمبر': 9, 'اکتوبر': 10, 'نومبر': 11, 'دسمبر': 12,
  };

  /// تاریخ کی جانچ: مقررہ تاریخ آنے یا گزرنے پر فوری اوور ڈیو (True) کرے گا
  static bool isDueOrPassed(String? dateStr, {int installmentNo = 2}) {
    if (installmentNo == 1) return true; // ایڈوانس ہمیشہ موقع پر ڈیو ہے
    if (dateStr == null || dateStr.trim().isEmpty) return false;

    DateTime? d = DateTime.tryParse(dateStr.trim());

    if (d == null) {
      int? foundMonth;
      for (final entry in _urduMonths.entries) {
        if (dateStr.contains(entry.key)) {
          foundMonth = entry.value;
          break;
        }
      }

      final numbers = RegExp(r'\d+')
          .allMatches(dateStr)
          .map((m) => int.parse(m.group(0)!))
          .toList();

      if (numbers.isNotEmpty) {
        int year = numbers.firstWhere((n) => n >= 2020, orElse: () => DateTime.now().year);
        int day = numbers.firstWhere((n) => n <= 31 && n != year, orElse: () => 1);
        int month = foundMonth ?? (numbers.length > 2 ? numbers[1] : DateTime.now().month);
        d = DateTime(year, month, day);
      }
    }

    if (d == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(d.year, d.month, d.day);

    return today.isAfter(dueDay) || today.isAtSameMomentAs(dueDay);
  }
}