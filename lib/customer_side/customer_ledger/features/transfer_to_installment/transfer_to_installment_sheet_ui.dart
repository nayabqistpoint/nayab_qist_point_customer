import 'package:flutter/material.dart';
import 'transfer_to_installment_args.dart';
import 'transfer_to_installment_controller.dart';

class TransferToInstallmentSheetUi {
  TransferToInstallmentSheetUi._();

  static Future<TransferToInstallmentResult?> show({
    required BuildContext context,
    TransferToInstallmentArgs? args,
    String? customerPhone,
    int? availableGreenAdvance,
    List<Map<String, dynamic>>? customerProducts,
    String Function(int)? formatAmount,
  }) {
    final effectiveArgs = args ??
        TransferToInstallmentArgs(
          customerPhone: customerPhone ?? '',
          products: customerProducts ?? [],
          availableGreenAdvance: availableGreenAdvance ?? 0,
        );

    final controller = TransferToInstallmentController(args: effectiveArgs);

    return showModalBottomSheet<TransferToInstallmentResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ListenableBuilder(
        listenable: controller,
        builder: (ctx, _) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 18,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 18,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'نقد ایڈوانس سے قسط میں منتقلی',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F766E),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const Divider(),
                  Text(
                    'دستیاب نقد ایڈوانس رقم: Rs. ${controller.formatAmount(controller.availableGreenAdvance)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF059669),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    initialValue: controller.selectedIndex,
                    items: List.generate(
                      controller.products.length,
                      (i) => DropdownMenuItem(
                        value: i,
                        child: Text(
                          '${controller.products[i]['name'] ?? controller.products[i]['title']} - بقایا: Rs. ${controller.formatAmount(controller.products[i]['remaining'] ?? 0)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    onChanged: (v) => v != null ? controller.selectProduct(v) : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: controller.amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'زیادہ سے زیادہ رقم: Rs. ${controller.formatAmount(controller.maxAllowed)}',
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
                      onPressed: controller.isSubmitting
                          ? null
                          : () async {
                              final validationError = controller.validate();
                              if (validationError != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(validationError),
                                    backgroundColor: const Color(0xFFDC2626),
                                  ),
                                );
                                return;
                              }
                              final result = await controller.submitTransfer();
                              if (ctx.mounted) {
                                Navigator.pop(ctx, result);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F766E),
                        foregroundColor: Colors.white,
                      ),
                      child: controller.isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'واٹر فال منتقلی کریں',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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