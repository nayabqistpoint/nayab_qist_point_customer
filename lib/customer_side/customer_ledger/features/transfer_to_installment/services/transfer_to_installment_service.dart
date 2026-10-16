import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/features/universal_payment_feature/universal_payment_page.dart';

class TransferToInstallmentService {
  static Future<void> executeTransfer({
    required BuildContext context,
    required Map<String, dynamic> targetProduct,
    required int amount,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UniversalPaymentPage(
          title: 'نقد کھاتے سے قسط منتقلی (${targetProduct['name']})',
          baseAmount: amount,
          isInstallment: true,
          itemName: targetProduct['name']?.toString() ?? 'موبائل فون',
          planTitle: targetProduct['plan']?.toString() ?? 'اقساط پلان',
          maxAllowedAmount: (targetProduct['remaining'] as int?) ?? 0,
        ),
      ),
    );
  }
}