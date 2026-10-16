import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';

class TransactionLedgerService {
  static Future<Box> ensureBoxOpen() async {
    return await HiveBoxManager.openSafeBox(HiveBoxManager.transactionBoxName);
  }

  static ValueListenable<Box>? get boxListenable {
    if (Hive.isBoxOpen(HiveBoxManager.transactionBoxName)) {
      return Hive.box(HiveBoxManager.transactionBoxName).listenable();
    }
    return null;
  }

  /// کسٹمر کے تمام لین دین کی تاریخ وار لسٹ نکالنا (تازہ ترین سب سے اوپر)
  static Future<List<Map<String, dynamic>>> getCustomerTransactions(String customerPhone) async {
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
          final Map<String, dynamic> entry = Map<String, dynamic>.from(rawData);
          entry['key'] = key;
          results.add(entry);
        }
      }
    }

    // تاریخ کے لحاظ سے سارٹ (تازہ ترین پہلے)
    results.sort((a, b) {
      final String dateA = (a['date'] ?? a['paymentDate'] ?? '').toString();
      final String dateB = (b['date'] ?? b['paymentDate'] ?? '').toString();
      return dateB.compareTo(dateA);
    });

    return results;
  }
}