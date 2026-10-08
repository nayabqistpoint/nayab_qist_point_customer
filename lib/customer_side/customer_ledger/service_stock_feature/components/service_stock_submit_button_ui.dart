import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/service_stock_controller.dart';
import 'package:nayab_qist_point_customer/customer_side/payload_services/service_stock_payload_service.dart';

class ServiceStockSubmitButtonUi extends StatelessWidget {
  final ServiceStockController controller;
  const ServiceStockSubmitButtonUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () async {
          final isMobile = controller.isMobileSupplierMode;

          if (isMobile && controller.mobileService.supplierStockList.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('برائے مہربانی پہلے کم از کم ایک موبائل درج کریں')),
            );
            return;
          }

          if (!isMobile) {
            if (controller.groceryService.groceryList.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('برائے مہربانی پہلے راشن آئٹمز شامل کریں')),
              );
              return;
            }

            if (controller.accountType == 0) {
              if (controller.customerProducts.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('اس کسٹمر کے نام پر کوئی فعال قسط موجود نہیں ہے')),
                );
                return;
              }

              if (controller.isOverMaxLimit) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'راشن کا کل بل (Rs. ${controller.formatAmount(controller.groceryTotal)}) اس پلان کے کل بقایا (Rs. ${controller.formatAmount(controller.maxAllowedLimit)}) سے زیادہ نہیں ہو سکتا۔',
                    ),
                    backgroundColor: const Color(0xFFDC2626),
                  ),
                );
                return;
              }
            }
          }

          final success = await ServiceStockPayloadService.executeSubmission(controller);

          if (success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('اندراج کامیابی سے محفوظ ہو گیا'), backgroundColor: Color(0xFF0D9488)),
            );
            Navigator.pop(context, true);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D9488),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
        ),
        child: Text(
          controller.isMobileSupplierMode
              ? 'موبائل اسٹاک جمع کریں (کل فونز: ${controller.mobileService.supplierStockList.length})'
              : 'راشن بل جمع کریں (کل رقم: Rs. ${controller.formatAmount(controller.groceryTotal)})',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}