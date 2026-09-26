import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../hive_services/hive_box_manager.dart';
import '../ledger_services/ledger_math_service.dart';

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
          int totalOrderAmount = 0;
          int totalPaidAmount = 0;

          for (final inst in installmentsList) {
            if (inst is Map) {
              final dueAmount = (inst['dueAmount'] as num?)?.toInt() ?? 0;
              final paidAmount = (inst['paidAmount'] as num?)?.toInt() ?? 0;
              final remainingAmount = (inst['remainingAmount'] as num?)?.toInt() ?? (dueAmount - paidAmount);
              final String dueDateStr = (inst['dueDate'] ?? '').toString();
              final String vStatus = (inst['verificationStatus'] ?? 'UNDER_REVIEW').toString();

              final computedStatus = LedgerMathService.resolveInstallmentStatus(
                dueAmount: dueAmount,
                paidAmount: paidAmount,
                remainingAmount: remainingAmount,
                dueDateStr: dueDateStr,
              );

              int percent = 0;
              if (computedStatus == 'PAID' || remainingAmount <= 0) {
                percent = 100;
              } else if (dueAmount > 0) {
                percent = LedgerMathService.calculatePercentage(paidAmount, dueAmount);
              }

              totalOrderAmount += dueAmount;
              totalPaidAmount += paidAmount;

              parsedSchedule.add({
                'no': inst['installmentNo'] ?? (parsedSchedule.length + 1),
                'date': dueDateStr,
                'dueDate': dueDateStr,
                'amount': dueAmount,
                'paidAmount': paidAmount,
                'remainingAmount': remainingAmount,
                'status': computedStatus,
                'verificationStatus': vStatus,
                'percent': percent,
                'title': inst['title']?.toString() ?? '',
                'raw': inst,
              });
            }
          }

          final totalMonths = (rawData['totalMonths'] as num?)?.toInt() ?? parsedSchedule.length;
          final monthlyAmount = (rawData['monthlyAmount'] as num?)?.toInt() ?? 0;
          final orderStatus = (rawData['status'] ?? 'PENDING').toString().toUpperCase();
          final int remainingBalance = totalOrderAmount - totalPaidAmount;

          results.add({
            'orderKey': key,
            'orderId': rawData['docId']?.toString() ?? rawData['orderId']?.toString() ?? key.toString(),
            'name': rawData['itemName']?.toString() ?? 'موبائل فون',
            'plan': '$totalMonths ماہ پلان',
            'monthlyInstallment': monthlyAmount,
            'total': totalOrderAmount,
            'paid': totalPaidAmount,
            'remaining': remainingBalance,
            'orderStatus': orderStatus,
            'isCompleted': remainingBalance <= 0 && totalOrderAmount > 0,
            'schedule': parsedSchedule,
            'rawOrder': rawData,
          });
        }
      }
    }
    return results;
  }
}