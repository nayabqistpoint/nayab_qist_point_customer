import 'dart:math';
import 'package:flutter/material.dart';
import 'transfer_to_installment_controller.dart';
import '../../../../payload_services/transfer_to_installment_payload_service.dart';

class TransferToInstallmentSheetUi {
  static void show({
    required BuildContext context,
    required String customerPhone,
    required int availableGreenAdvance, // دستیاب منفی کیش ایڈوانس (مثبت عدد کی صورت میں، جیسے 5000)
    required List<Map<String, dynamic>> customerProducts,
    required String Function(int) formatAmount,
  }) {
    final controller = TransferToInstallmentController(products: customerProducts);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ListenableBuilder(
        listenable: controller,
        builder: (ctx, _) {
          final maxAllowed = min(availableGreenAdvance, controller.maxRemaining);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 18, bottom: MediaQuery.of(ctx).viewInsets.bottom + 18),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('نقد ایڈوانس سے قسط میں منتقلی', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                      IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close_rounded)),
                    ],
                  ),
                  const Divider(),
                  Text(
                    'دستیاب نقد ایڈوانس رقم: Rs. ${formatAmount(availableGreenAdvance)}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    initialValue: controller.selectedIndex,
                    items: List.generate(
                      customerProducts.length,
                      (i) => DropdownMenuItem(
                        value: i,
                        child: Text('${customerProducts[i]['name']} - بقایا: Rs. ${formatAmount(customerProducts[i]['remaining'] ?? 0)}', style: const TextStyle(fontSize: 12)),
                      ),
                    ),
                    onChanged: (v) => v != null ? controller.selectProduct(v) : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: controller.amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'زیادہ سے زیادہ رقم: Rs. ${formatAmount(maxAllowed)}',
                      prefixText: 'Rs. ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () async {
                        final inputAmt = controller.parsedAmount;
                        if (inputAmt <= 0) return;
                        if (inputAmt > maxAllowed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('رقم دستیاب ایڈوانس (Rs. ${formatAmount(maxAllowed)}) سے زیادہ نہیں ہو سکتی'), backgroundColor: const Color(0xFFDC2626)),
                          );
                          return;
                        }

                        Navigator.pop(ctx);
                        await TransferToInstallmentPayloadService.executeTransfer(
                          customerPhone: customerPhone,
                          contractDocId: controller.currentProduct?['docId']?.toString() ?? '',
                          productName: controller.currentProduct?['name']?.toString() ?? 'موبائل فون',
                          transferAmount: inputAmt,
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
                      child: const Text('واٹر فال منتقلی کریں', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}