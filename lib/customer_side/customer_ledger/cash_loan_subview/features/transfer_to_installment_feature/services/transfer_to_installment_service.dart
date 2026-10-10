import 'package:flutter/material.dart';
import '../../../../shared/customer_session_context_service.dart';

class TransferToInstallmentService {
  static Future<void> executeTransfer({
    required BuildContext context,
    required Map<String, dynamic> targetProduct,
    required int amount,
  }) async {
    await CustomerSessionContextService.openUniversalPayment(
      context,
      title: 'نقد کھاتے سے قسط منتقلی (${targetProduct['name']})',
      baseAmount: amount,
      isInstallment: true,
      itemName: targetProduct['name']?.toString() ?? 'موبائل فون',
      planTitle: targetProduct['plan']?.toString() ?? 'اقساط پلان',
      maxAllowedAmount: (targetProduct['remaining'] as int?) ?? 0,
    );
  }
}