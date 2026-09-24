class CalculatorConfigModel {
  final bool addProcessingFeeToPrincipal;
  final double advancePercentage;
  final List<int> allowedDurations;
  final int gracePeriodDays;
  final int installmentDueDay;
  final bool isCompoundingProfit;
  final double perMonthIncrement;
  final int processingFee;
  final double profitWithCheck;
  final double profitWithoutCheck;
  final int roundToNearest;
  final String status;

  const CalculatorConfigModel({
    required this.addProcessingFeeToPrincipal,
    required this.advancePercentage,
    required this.allowedDurations,
    required this.gracePeriodDays,
    required this.installmentDueDay,
    required this.isCompoundingProfit,
    required this.perMonthIncrement,
    required this.processingFee,
    required this.profitWithCheck,
    required this.profitWithoutCheck,
    required this.roundToNearest,
    required this.status,
  });

  /// ڈیٹا بیس دستیاب نہ ہونے یا کرپٹ ہونے کی صورت میں محفوظ ڈیفالٹس
  factory CalculatorConfigModel.fallback() {
    return const CalculatorConfigModel(
      addProcessingFeeToPrincipal: false,
      advancePercentage: 0.8,
      allowedDurations: [6, 7, 8, 9, 10, 11, 12],
      gracePeriodDays: 15,
      installmentDueDay: 5,
      isCompoundingProfit: false,
      perMonthIncrement: 0.05,
      processingFee: 0,
      profitWithCheck: 0.25,
      profitWithoutCheck: 0.35,
      roundToNearest: 100,
      status: 'approved',
    );
  }

  /// ہائیو یا فائر اسٹور میپ سے پارس کرنے کا محفوظ فیکٹری فنکشن
  factory CalculatorConfigModel.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return CalculatorConfigModel.fallback();

    List<int> parseDurations(dynamic raw) {
      if (raw is List) {
        final parsed = raw
            .map((e) => int.tryParse(e.toString()) ?? 0)
            .where((e) => e > 0)
            .toList();
        if (parsed.isNotEmpty) return parsed;
      }
      return [6, 7, 8, 9, 10, 11, 12];
    }

    return CalculatorConfigModel(
      addProcessingFeeToPrincipal: map['addProcessingFeeToPrincipal'] == true,
      advancePercentage: (map['advancePercentage'] as num?)?.toDouble() ?? 0.8,
      allowedDurations: parseDurations(map['allowedDurations']),
      gracePeriodDays: (map['gracePeriodDays'] as num?)?.toInt() ?? 15,
      installmentDueDay: (map['installmentDueDay'] as num?)?.toInt() ?? 5,
      isCompoundingProfit: map['isCompoundingProfit'] == true,
      perMonthIncrement: (map['perMonthIncrement'] as num?)?.toDouble() ?? 0.05,
      processingFee: (map['processingFee'] as num?)?.toInt() ?? 0,
      profitWithCheck: (map['profitWithCheck'] as num?)?.toDouble() ?? 0.25,
      profitWithoutCheck: (map['profitWithoutCheck'] as num?)?.toDouble() ?? 0.35,
      roundToNearest: (map['roundToNearest'] as num?)?.toInt() ?? 100,
      status: map['status']?.toString() ?? 'approved',
    );
  }
}