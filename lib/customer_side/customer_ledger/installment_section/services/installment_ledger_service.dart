import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/installment_section/services/ledger_math_service.dart';

class InstallmentLedgerService {
  static Future<Box> ensureBoxOpen() async {
    return await HiveBoxManager.openSafeBox(HiveBoxManager.installmentsBoxName);
  }

  static ValueListenable<Box>? get boxListenable {
    if (Hive.isBoxOpen(HiveBoxManager.installmentsBoxName)) {
      return Hive.box(HiveBoxManager.installmentsBoxName).listenable();
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> getCustomerInstallmentOrders(String customerPhone) async {
    final box = await ensureBoxOpen();
    final cleanPhone = customerPhone.replaceAll(RegExp(r'\s+'), '').trim();
    final List<Map<String, dynamic>> results = [];

    for (var key in box.keys) {
      final rawData = box.get(key);
      if (rawData is Map) {
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

              // کارڈز کے حساب کے لیے صرف منظور شدہ رقم
              final effectivePaid = isApproved ? rawPaidAmount : 0;
              final int remainingAmount = (dueAmount - effectivePaid).clamp(0, dueAmount);

              final computedStatus = LedgerMathService.resolveInstallmentStatus(
                dueAmount: dueAmount,
                approvedPaidAmount: effectivePaid,
                remainingAmount: remainingAmount,
                dueDateStr: dueDateStr,
              );

              // پروگریس بار کا فیصد
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
            'orderKey': key,
            'orderId': rawData['docId']?.toString() ?? rawData['orderId']?.toString() ?? key.toString(),
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
    }
    return results;
  }
}