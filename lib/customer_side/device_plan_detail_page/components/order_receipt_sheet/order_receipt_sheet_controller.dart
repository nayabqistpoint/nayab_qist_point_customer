import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'package:nayab_qist_point_customer/customer_side/payload_services/purchase_order_payload_service.dart';
import 'package:nayab_qist_point_customer/customer_side/sync/master_sync_hub.dart';
import 'sign_up_barrier_dialog_ui.dart';

class OrderReceiptSheetController extends ChangeNotifier {
  final Map<String, dynamic> plan;
  final TextEditingController bankNameCtrl = TextEditingController();
  final TextEditingController chequeNoCtrl = TextEditingController();

  late final int advance;
  late final int monthly;
  late final int months;
  late final int totalInstallmentSum;
  late final bool isChequePlan;
  late final String tokenNo;

  String? localError;
  bool isSubmitting = false;

  OrderReceiptSheetController({required this.plan}) {
    advance = (plan['advance'] as num?)?.toInt() ?? 0;
    monthly = (plan['monthly'] as num?)?.toInt() ?? 0;
    months = (plan['months'] as num?)?.toInt() ?? 6;
    totalInstallmentSum = advance + (monthly * months);
    isChequePlan = plan['guarantee'] == 'BANK_CHEQUE';
    tokenNo = 'NQP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  }

  @override
  void dispose() {
    bankNameCtrl.dispose();
    chequeNoCtrl.dispose();
    super.dispose();
  }

  Future<void> submitOrder({
    required BuildContext context,
    required String deviceName,
    required String? customerPhone,
    required String? sourceMode,
    required String? imeiNo,
  }) async {
    if (isChequePlan && (bankNameCtrl.text.trim().isEmpty || chequeNoCtrl.text.trim().isEmpty)) {
      localError = 'برائے مہربانی بینک کا نام اور چیک نمبر درج کریں!';
      notifyListeners();
      return;
    }

    if (customerPhone == null || customerPhone.trim().isEmpty) {
      Navigator.pop(context);
      SignUpBarrierDialogUi.show(context);
      return;
    }

    isSubmitting = true;
    localError = null;
    notifyListeners();

    try {
      final payload = PurchaseOrderPayloadService.buildOrderPayload(
        orderId: tokenNo,
        customerPhone: customerPhone.trim(),
        sourceMode: sourceMode ?? 'STOCK',
        itemName: deviceName,
        imeiNo: imeiNo,
        guaranteeType: plan['guarantee'] ?? 'LEGAL_STAMP',
        bankName: bankNameCtrl.text,
        chequeNo: chequeNoCtrl.text,
        totalMonths: months,
        advancePaid: advance,
        monthlyAmount: monthly,
        orderDateTime: DateTime.now(),
      );

      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.installmentsBoxName);
      await box.put(tokenNo, payload);

      MasterSyncHub.pushAllPendingRecords().catchError((_) {});

      if (!context.mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('آرڈر $tokenNo کسٹمر $customerPhone کے کھاتے میں ارسال ہو گیا!'),
          backgroundColor: const Color(0xFF059669),
        ),
      );
    } catch (e) {
      isSubmitting = false;
      localError = 'آرڈر محفوظ کرتے وقت مسئلہ پیش آیا، دوبارہ کوشش کریں۔';
      notifyListeners();
    }
  }
}