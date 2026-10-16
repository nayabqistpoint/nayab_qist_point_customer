import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'cash_loan_payload_service.dart';

class CashLoanStorageHandler {
  /// کسٹمر کا موجودہ بیلنس اور اس کی ٹرانزیکشنز پڑھتا ہے
  static Future<Map<String, dynamic>> loadCashLoanData(String customerPhone) async {
    final custBox = await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);
    final custData = custBox.get(customerPhone);
    final int balance = (custData is Map) ? ((custData['cashLoanBalance'] as num?)?.toInt() ?? 0) : 0;

    final txBox = await HiveBoxManager.openSafeBox(HiveBoxManager.transactionBoxName);
    final List<Map<String, dynamic>> entries = [];

    for (var val in txBox.values) {
      if (val is Map && val['customerPhone'] == customerPhone) {
        entries.add(Map<String, dynamic>.from(val));
      }
    }

    entries.sort((a, b) {
      final tA = a['timestamp']?.toString() ?? '';
      final tB = b['timestamp']?.toString() ?? '';
      return tB.compareTo(tA);
    });

    return {
      'balance': balance,
      'entries': entries,
    };
  }

  /// ہائیو باکسز کی تبدیلیوں کو لائیو سنتا ہے
  static Future<List<StreamSubscription>> watchCashLoanChanges({
    required String customerPhone,
    required VoidCallback onDataChanged,
  }) async {
    final txBox = await HiveBoxManager.openSafeBox(HiveBoxManager.transactionBoxName);
    final custBox = await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);

    return [
      txBox.watch().listen((_) => onDataChanged()),
      custBox.watch(key: customerPhone).listen((_) => onDataChanged()),
    ];
  }

  /// پے لوڈ بنوا کر ٹرانزیکشن کو ہائیو بیچ میں محفوظ اور کلاؤڈ سنک ٹریگر کرتا ہے
  static Future<bool> processRepayment({
    required String customerPhone,
    required int paidAmount,
    required int discountAmount,
    required List<Map<String, dynamic>> splits,
    required String note,
    String receiptImagePath = '',
    String voiceNotePath = '',
  }) async {
    try {
      final txnRecord = CashLoanPayloadService.buildRepaymentPayload(
        customerPhone: customerPhone,
        paidAmount: paidAmount,
        discountAmount: discountAmount,
        splits: splits,
        note: note,
        receiptImagePath: receiptImagePath,
        voiceNotePath: voiceNotePath,
      );

      return await HiveBoxManager.writeBatchPayloads(
        docId: customerPhone,
        payloads: {
          HiveBoxManager.transactionBoxName: txnRecord,
        },
        logTitle: 'نقد قرض واپسی ٹرانزیکشن بیچ محفوظ ہوئی',
      );
    } catch (e) {
      debugPrint('❌ CashLoanStorageHandler Error: $e');
      return false;
    }
  }
}