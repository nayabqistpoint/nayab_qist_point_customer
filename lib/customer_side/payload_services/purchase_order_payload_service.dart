import '../device_plan_detail_page/services/calculator_config_model.dart';
import '../device_plan_detail_page/services/plan_schedule_service.dart';

class PurchaseOrderPayloadService {
  static Map<String, dynamic> buildOrderPayload({
    required String docId,
    required String customerPhone,
    required String sourceMode, // 'STOCK' یا 'CUSTOM_ESTIMATE'
    required String itemName,
    String? imeiNo,
    required String guaranteeType, // 'BANK_CHEQUE' یا 'LEGAL_STAMP'
    String? bankName,
    String? chequeNo,
    required int totalMonths,
    required int advance,
    required int monthlyAmount,
    required int totalContractAmount,
    required DateTime orderDateTime,
    CalculatorConfigModel? config,
  }) {
    final bool isCheque = guaranteeType == 'BANK_CHEQUE';

    // 🎯 مستند PlanScheduleService سے شیڈول حاصل کیا گیا، کوئی الگ لاجک نہیں لگائی گئی
    final effectiveConfig = config ?? CalculatorConfigModel.fallback();
    final generatedSchedule = PlanScheduleService.generateSchedule(
      totalMonths: totalMonths,
      monthlyAmount: monthlyAmount,
      advancePaid: advance,
      config: effectiveConfig,
      requestDate: orderDateTime,
    );

    final List<Map<String, dynamic>> finalInstallments = [];

    for (int i = 0; i < generatedSchedule.length; i++) {
      final item = generatedSchedule[i];
      final int instNo = (item['no'] as num?)?.toInt() ?? (i + 1);
      final int amt = (item['amount'] as num?)?.toInt() ?? 0;
      final bool isFirst = instNo == 1;

      // اگر زیرو ایڈوانس پلان ہو تو پہلی قسط خود بخود مکمل ادا شدہ مانی جائے گی
      final bool isZeroAdv = isFirst && advance == 0;

      finalInstallments.add({
        'installmentNo': instNo,
        'title': isFirst
            ? (advance > 0 ? 'ایڈوانس قسط (قسط نمبر 1)' : 'زیرو ایڈوانس (قسط نمبر 1)')
            : 'ماہانہ قسط نمبر $instNo',
        'dueDate': item['dueDate']?.toString() ?? '',
        'dueAmount': amt,
        'paidAmount': 0,
        'remainingAmount': amt,
        'paymentPercentage': isZeroAdv ? 100 : 0,
        'status': isZeroAdv ? 'PAID' : 'PENDING',
      });
    }

    return {
      'docId': docId,
      'customerPhone': customerPhone,
      'sourceMode': sourceMode,
      'itemName': itemName,
      'imeiNo': (imeiNo != null && imeiNo.trim().isNotEmpty) ? imeiNo.trim() : null,
      'guaranteeType': guaranteeType,
      'bankName': isCheque ? (bankName?.trim() ?? '') : null,
      'chequeNo': isCheque ? (chequeNo?.trim() ?? '') : null,
      'totalMonths': totalMonths,
      'advance': advance,
      'monthlyAmount': monthlyAmount,
      'totalContractAmount': totalContractAmount,
      'status': 'PENDING',
      'isSynced': false,
      'createdAt': orderDateTime.toIso8601String(),
      'installments': finalInstallments,
    };
  }
}