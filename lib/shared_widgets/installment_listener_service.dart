import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/shared_widgets/installment_plan_dialog_logic.dart';

class InstallmentListenerService {
  static ValueListenable<Box> get packageBoxListenable => Hive.box('packageBox').listenable();
  static ValueListenable<Box> get transactionBoxListenable => Hive.box('transactionBox').listenable();

  static InstallmentTableDataModel? getTableData(String customerPhone) {
    if (!Hive.isBoxOpen('packageBox') || !Hive.isBoxOpen('transactionBox')) return null;

    return InstallmentPlanDialogLogic.processInstallmentData(
      customerPhone: customerPhone,
      packageBox: Hive.box('packageBox'),
      transactionBox: Hive.box('transactionBox'),
    );
  }
}