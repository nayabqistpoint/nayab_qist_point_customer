import 'package:flutter/material.dart';
import 'transfer_to_installment_controller.dart';
import '../../../../payload_services/transfer_to_installment_payload_service.dart';

class TransferToInstallmentSheetUi {
  static void show({
    required BuildContext context,
    required String customerPhone,
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
        builder: (ctx, _) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 18, bottom: MediaQuery.of(ctx).viewInsets.bottom + 18),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('نقد کھاتے سے قسط میں منتقلی', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                    IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close_rounded)),
                  ],
                ),
                const Divider(),
                DropdownButtonFormField<int>(
                  initialValue: controller.selectedIndex,
                  items: List.generate(
                    customerProducts.length,
                    (i) => DropdownMenuItem(
                      value: i,
                      child: Text('${customerProducts[i]['name']} - بقایا: Rs. ${formatAmount(customerProducts[i]['remaining'] ?? 0)}'),
                    ),
                  ),
                  onChanged: (v) => v != null ? controller.selectProduct(v) : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controller.amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'زیادہ سے زیادہ: Rs. ${formatAmount(controller.maxRemaining)}', prefixText: 'Rs. '),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.validate() != null) return;
                      Navigator.pop(ctx);
                      await TransferToInstallmentPayloadService.executeTransfer(
                        customerPhone: customerPhone,
                        targetProduct: controller.currentProduct!,
                        transferAmount: controller.parsedAmount,
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
                    child: const Text('رقم منتقل کریں'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}