class PurchaseOrderPayloadService {
  static Map<String, dynamic> buildOrderPayload({
    required String orderId,
    required String customerPhone,
    required String sourceMode, // 'STOCK' یا 'CUSTOM_ESTIMATE'
    required String itemName,
    String? imeiNo,
    required String guaranteeType, // 'BANK_CHEQUE' یا 'LEGAL_STAMP'
    String? bankName,
    String? chequeNo,
    required int totalMonths,
    required int advancePaid,
    required int monthlyAmount,
    required DateTime orderDateTime,
  }) {
    final bool isCheque = guaranteeType == 'BANK_CHEQUE';
    final List<Map<String, dynamic>> scheduleRows = [];

    // ۱. قسط نمبر 1 (ہمیشہ ایڈوانس ادائیگی)
    scheduleRows.add({
      'installmentNo': 1,
      'title': 'ایڈوانس قسط (قسط نمبر 1)',
      'monthLabel': _formatMonthYear(orderDateTime),
      'dueDate': orderDateTime.toIso8601String(),
      'dueAmount': advancePaid,
      'paidAmount': advancePaid == 0 ? 0 : 0,
      'remainingAmount': advancePaid,
      'paymentPercentage': advancePaid == 0 ? 100.0 : 0.0,
      'status': advancePaid == 0 ? 'FULLY_PAID' : 'PENDING',
    });

    // ۲. بقیہ ماہانہ اقساط (مثلاً 6 ماہ کا پلان ہے تو قسط نمبر 2 سے 6 تک کل 5 اقساط)
    for (int i = 2; i <= totalMonths; i++) {
      final int monthOffset = i - 1;
      final dueDate = DateTime(
        orderDateTime.year,
        orderDateTime.month + monthOffset,
        orderDateTime.day,
      );

      scheduleRows.add({
        'installmentNo': i,
        'title': 'ماہانہ قسط نمبر $i',
        'monthLabel': _formatMonthYear(dueDate),
        'dueDate': dueDate.toIso8601String(),
        'dueAmount': monthlyAmount,
        'paidAmount': 0,
        'remainingAmount': monthlyAmount,
        'paymentPercentage': 0.0,
        'status': 'PENDING',
      });
    }

    return {
      'orderId': orderId,
      'customerPhone': customerPhone,
      'sourceMode': sourceMode,
      'createdAt': orderDateTime.toIso8601String(),
      'status': 'PENDING',
      'isSynced': false,
      'itemName': itemName,
      'imeiNo': (imeiNo != null && imeiNo.trim().isNotEmpty) ? imeiNo.trim() : null,
      'guaranteeType': guaranteeType,
      'bankName': isCheque ? (bankName?.trim() ?? '') : null,
      'chequeNo': isCheque ? (chequeNo?.trim() ?? '') : null,
      'totalMonths': totalMonths,
      'advancePaid': advancePaid,
      'monthlyAmount': monthlyAmount,
      'installments': scheduleRows,
    };
  }

  static String _formatMonthYear(DateTime date) {
    const urduMonths = [
      'جنوری', 'فروری', 'مارچ', 'اپریل', 'مئی', 'جون',
      'جولائی', 'اگست', 'ستمبر', 'اکتوبر', 'نومبر', 'دسمبر'
    ];
    return '${date.day} ${urduMonths[date.month - 1]} ${date.year}';
  }
}