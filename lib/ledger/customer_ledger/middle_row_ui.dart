import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/ledger/customer_ledger/customer_ledger_controller.dart';
import 'package:nayab_qist_point_customer/ledger/customer_ledger/ledger_listener_service.dart';
import 'package:nayab_qist_point_customer/ledger/customer_ledger/middle_row_logic.dart';

class MiddleRowUi extends StatelessWidget {
  final CustomerLedgerController controller;

  const MiddleRowUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: LedgerListenerService.getTransactionListenable(),
      builder: (context, box, _) {
        final items = MiddleRowLogic.process(
          box: box,
          customerPhone: controller.customerPhone,
        );

        if (items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "کوئی ٹرانزیکشن موجود نہیں ہے",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: item.isApproved
                    ? Border.all(color: Colors.grey.shade300, width: 0.8)
                    : Border.all(color: Colors.green.shade600, width: 1.2),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        // 🎯 رقم کا ڈسپلے (پینڈنگ کی صورت میں اورنج، منظور شدہ کے لیے سبز/سرخ)
                        Text(
                          item.amountText,
                          style: TextStyle(
                            color: item.amountColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(item.year,
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.grey)),
                                const SizedBox(width: 3),
                                Text(item.month,
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.grey)),
                                const SizedBox(width: 3),
                                Text(
                                  item.day,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.attach_file,
                                    size: 12, color: Colors.grey),
                                const SizedBox(width: 6),
                                SizedBox(
                                  width: 90,
                                  height: 24,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 1),
                                    ),
                                    child: Text(
                                      item.runningBalanceText,
                                      style: TextStyle(
                                        // 🎯 لاجک سے آنے والا متحرک رنگ (مثبت پر سبز، منفی پر سرخ)
                                        color: item.runningBalanceColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.description,
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // 🎯 پینڈنگ سٹیٹس کی پٹی
                  if (!item.isApproved)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(7)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hourglass_top_rounded,
                              size: 13, color: Colors.green.shade900),
                          const SizedBox(width: 4),
                          Text(
                            "تصدیق کی جا رہی ہے، براہِ کرم انتظار فرمائیں...",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}