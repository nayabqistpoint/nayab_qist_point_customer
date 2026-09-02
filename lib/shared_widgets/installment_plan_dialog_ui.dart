import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:nayab_qist_point_customer/shared_widgets/installment_listener_service.dart';
import 'package:nayab_qist_point_customer/shared_widgets/installment_plan_dialog_logic.dart';
import 'package:nayab_qist_point_customer/shared_widgets/installment_table_row_widget.dart';

void showInstallmentPlanDialog(BuildContext context, String customerPhone, {bool isAdmin = false}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => InstallmentPlanDialogUi(
      customerPhone: customerPhone,
      isAdmin: isAdmin,
    ),
  );
}

class InstallmentPlanDialogUi extends StatelessWidget {
  final String customerPhone;
  final bool isAdmin;

  const InstallmentPlanDialogUi({
    super.key,
    required this.customerPhone,
    this.isAdmin = false,
  });

  static void show(BuildContext context, String customerPhone, {bool isAdmin = false}) {
    showInstallmentPlanDialog(context, customerPhone, isAdmin: isAdmin);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
      child: Container(
        width: screenSize.width * 0.95,
        height: screenSize.height * 0.85,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.indigo.shade200, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDialogHeader(context),
            const Divider(height: 16, thickness: 1.2),

            // 🎯 لائیو لسنرز پر ڈائریکٹ اور ریئل ٹائم بلڈ
            Expanded(
              child: ValueListenableBuilder<Box>(
                valueListenable: InstallmentListenerService.packageBoxListenable,
                builder: (context, box1, child1) {
                  return ValueListenableBuilder<Box>(
                    valueListenable: InstallmentListenerService.transactionBoxListenable,
                    builder: (context, box2, child2) {
                      final tableModel = InstallmentListenerService.getTableData(customerPhone);

                      if (tableModel == null) {
                        return const Center(
                          child: Text(
                            "اس کسٹمر کا کوئی ایکٹو اقساط کا پلان نہیں ملا!",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return _buildLiveInstallmentTable(context, tableModel);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade800,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("بند کریں", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.indigo.shade50, shape: BoxShape.circle),
              child: Icon(Icons.calendar_month, color: Colors.indigo.shade800, size: 24),
            ),
            const SizedBox(width: 10),
            const Text(
              "جدولِ اقساط و شارٹ ڈیو",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.grey, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildLiveInstallmentTable(BuildContext context, InstallmentTableDataModel tableModel) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: tableModel.isApproved ? Colors.indigo.shade50 : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: tableModel.isApproved ? Colors.indigo.shade100 : Colors.orange.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "ماڈل: ${tableModel.mobileName} (${tableModel.packageName}) ${tableModel.isApproved ? '' : '[پینڈنگ]'} ",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: tableModel.isApproved ? Colors.indigo.shade900 : Colors.orange.shade900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "کل قیمت: Rs ${tableModel.totalPrice.toStringAsFixed(0)}",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red.shade900),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  color: Colors.grey.shade100,
                  child: const Row(
                    children: [
                      Expanded(flex: 3, child: Text('قسط و تاریخ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87))),
                      Expanded(flex: 2, child: Text('واجب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87))),
                      Expanded(flex: 2, child: Text('وصول', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87))),
                      Expanded(flex: 4, child: Text('پروگریس / شارٹ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87), textAlign: TextAlign.center)),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),

                Expanded(
                  child: ListView.builder(
                    itemCount: tableModel.rows.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (indexContext, index) => InstallmentTableRowWidget(
                      inst: tableModel.rows[index],
                      customerPhone: customerPhone,
                      isAdmin: isAdmin,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red.shade400, width: 1.5),
            boxShadow: [
              BoxShadow(color: Colors.red.shade50, blurRadius: 6, offset: const Offset(0, 3))
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "تاریخ گزرنے پر واجب الادا شارٹ:",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                "Rs ${tableModel.totalOverdueShort.toStringAsFixed(0)}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red.shade900),
              ),
            ],
          ),
        ),
      ],
    );
  }
}