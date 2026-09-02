import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/shared_widgets/installment_plan_dialog_logic.dart';

class InstallmentListenerService {
  /// 🎯 ریئل ٹائم لائیو باکس لسنبلز
  static ValueListenable<Box> get packageBoxListenable {
    return Hive.box('packageBox').listenable();
  }

  static ValueListenable<Box> get transactionBoxListenable {
    return Hive.box('transactionBox').listenable();
  }

  static InstallmentTableDataModel? getTableData(String customerPhone) {
    if (!Hive.isBoxOpen('packageBox') || !Hive.isBoxOpen('transactionBox')) return null;

    return InstallmentPlanDialogLogic.processInstallmentData(
      customerPhone: customerPhone,
      packageBox: Hive.box('packageBox'),
      transactionBox: Hive.box('transactionBox'),
    );
  }
}