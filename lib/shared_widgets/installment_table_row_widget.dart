import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/ledger/pay_now/pay_now_widget.dart';
import 'package:nayab_qist_point_customer/shared_widgets/installment_plan_dialog_logic.dart';

class InstallmentTableRowWidget extends StatelessWidget {
  final InstallmentRowModel inst;
  final String customerPhone;
  final bool isAdmin;

  const InstallmentTableRowWidget({
    super.key,
    required this.inst,
    required this.customerPhone,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    double progress = inst.progress;
    bool isFullyPaid = progress >= 1.0;
    bool isOverdue = inst.isOverdue;
    int percentage = (progress * 100).round();

    Widget rowContent = Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // ۱۔ قسط و تاریخ
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(inst.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(inst.day, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isOverdue ? Colors.red.shade700 : Colors.grey.shade700)),
                      const SizedBox(width: 3),
                      Text(inst.monthText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isOverdue ? Colors.red.shade700 : Colors.grey.shade700)),
                      const SizedBox(width: 3),
                      Text(inst.year, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isOverdue ? Colors.red.shade700 : Colors.grey.shade700)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ۲۔ واجب رقم
          Expanded(
            flex: 2,
            child: Text("Rs ${inst.due}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),

          // ۳۔ وصول رقم
          Expanded(
            flex: 2,
            child: Text(
              "Rs ${inst.paid}",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: double.parse(inst.paid) > 0 ? Colors.green.shade800 : Colors.black54,
              ),
            ),
          ),

          // ۴۔ پروگریس بار اور شارٹ (رنگوں کی درست میپنگ)
          Expanded(
            flex: 4,
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isFullyPaid ? Colors.green.shade600 : (isOverdue ? Colors.red.shade400 : Colors.grey.shade300),
                  width: 1.2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  children: [
                    // سبز پٹی (جزوی یا مکمل ادا شدہ کی روشنی میں)
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(color: isFullyPaid ? Colors.green.shade600 : Colors.green.shade500),
                    ),
                    Center(
                      child: isFullyPaid
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, size: 14, color: Colors.white),
                                SizedBox(width: 4),
                                Text("100% مکمل", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 🎯 ادا شدہ فیصد: ہمیشہ واضح سفید رنگ میں
                                if (progress > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Text(
                                      "$percentage% ادا",
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                
                                // 🎯 شارٹ اماؤنٹ: ہمیشہ واضح سرخ (Red) رنگ میں
                                Text(
                                  isOverdue ? "-Rs ${inst.short}" : "آئندہ قسط",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isOverdue ? Colors.red.shade900 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (isAdmin) return rowContent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          Navigator.pop(context);
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PayNowWidget(
                customerMobileNumber: customerPhone,
                initialAmount: inst.amountToPay,
              ),
            ),
          );
        },
        splashColor: Colors.indigo.shade50,
        child: rowContent,
      ),
    );
  }
}