import 'installment_storage_handler.dart';
import 'ledger_math_service.dart';

class InstallmentLedgerService {
  InstallmentLedgerService._();

  /// 🎯 ڈیش بورڈ اور بیرونی فیچرز کے لیے کمپیٹیبلٹی میتھڈ
  /// یہ خود ہی StorageHandler سے را ڈیٹا منگوا کر پارس کرتا ہے تاکہ بلیو پرنٹ کی خلاف ورزی نہ ہو
  static Future<List<Map<String, dynamic>>> getCustomerInstallmentOrders(String customerPhone) async {
    final rawOrders = await InstallmentStorageHandler.fetchRawInstallmentOrders();
    return parseCustomerOrders(
      rawOrders: rawOrders,
      customerPhone: customerPhone,
    );
  }

  /// پیور لاجک میتھڈ
  static List<Map<String, dynamic>> parseCustomerOrders({
    required List<Map<String, dynamic>> rawOrders,
    required String customerPhone,
  }) {
    final cleanPhone = customerPhone.replaceAll(RegExp(r'\s+'), '').trim();
    final List<Map<String, dynamic>> results = [];

    for (final rawData in rawOrders) {
      final orderPhone = (rawData['customerPhone'] ?? '')
          .toString()
          .replaceAll(RegExp(r'\s+'), '')
          .trim();

      final bool isMatch = cleanPhone.isNotEmpty &&
          (orderPhone == cleanPhone ||
              (cleanPhone.length >= 10 && orderPhone.endsWith(cleanPhone.substring(cleanPhone.length - 10))));

      if (isMatch) {
        final installmentsList = (rawData['installments'] as List?) ?? [];
        final List<Map<String, dynamic>> parsedSchedule = [];
        int totalContractAmount = 0;
        int approvedPaidAmount = 0;
        int pendingUnderReviewAmount = 0;
        bool hasAnyUnderReview = false;

        for (final inst in installmentsList) {
          if (inst is Map) {
            final dueAmount = (inst['dueAmount'] as num?)?.toInt() ?? 0;
            final rawPaidAmount = (inst['paidAmount'] as num?)?.toInt() ?? 0;
            final String dueDateStr = (inst['dueDate'] ?? '').toString();
            final String vStatus = (inst['verificationStatus'] ?? 'UNDER_REVIEW').toString().toUpperCase();
            final bool isApproved = vStatus == 'APPROVED' || vStatus == 'VERIFIED';
            final bool isUnderReview = rawPaidAmount > 0 && !isApproved;

            if (isUnderReview) {
              hasAnyUnderReview = true;
              pendingUnderReviewAmount += rawPaidAmount;
            }

            final effectivePaid = isApproved ? rawPaidAmount : 0;
            final int remainingAmount = (dueAmount - effectivePaid).clamp(0, dueAmount);
            final computedStatus = LedgerMathService.resolveInstallmentStatus(
              dueAmount: dueAmount,
              approvedPaidAmount: effectivePaid,
              remainingAmount: remainingAmount,
              dueDateStr: dueDateStr,
            );

            int percent = 0;
            if (isApproved && remainingAmount <= 0) {
              percent = 100;
            } else if (dueAmount > 0) {
              percent = LedgerMathService.calculatePercentage(rawPaidAmount, dueAmount);
            }

            totalContractAmount += dueAmount;
            approvedPaidAmount += effectivePaid;

            parsedSchedule.add({
              'no': inst['installmentNo'] ?? (parsedSchedule.length + 1),
              'date': dueDateStr,
              'dueDate': dueDateStr,
              'amount': dueAmount,
              'paidAmount': rawPaidAmount,
              'remainingAmount': remainingAmount,
              'status': computedStatus,
              'verificationStatus': vStatus,
              'isUnderReview': isUnderReview,
              'isApproved': isApproved,
              'percent': percent,
              'title': inst['title']?.toString() ?? '',
              'raw': inst,
            });
          }
        }

        final totalMonths = (rawData['totalMonths'] as num?)?.toInt() ?? parsedSchedule.length;
        final monthlyAmount = (rawData['monthlyAmount'] as num?)?.toInt() ?? 0;
        final orderStatus = (rawData['status'] ?? 'PENDING').toString().toUpperCase();
        final int remainingBalance = (totalContractAmount - approvedPaidAmount).clamp(0, totalContractAmount);

        results.add({
          'orderKey': rawData['orderKey'],
          'orderId': rawData['docId']?.toString() ?? rawData['orderId']?.toString() ?? rawData['orderKey'].toString(),
          'name': rawData['itemName']?.toString() ?? 'موبائل فون',
          'plan': '$totalMonths ماہ پلان',
          'monthlyInstallment': monthlyAmount,
          'total': totalContractAmount,
          'paid': approvedPaidAmount,
          'remaining': remainingBalance,
          'pendingAmount': pendingUnderReviewAmount,
          'hasPendingReview': hasAnyUnderReview,
          'orderStatus': orderStatus,
          'isCompleted': remainingBalance <= 0 && totalContractAmount > 0,
          'schedule': parsedSchedule,
          'rawOrder': rawData,
        });
      }
    }
    return results;
  }
}