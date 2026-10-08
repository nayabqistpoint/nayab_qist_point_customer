import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/service_stock_controller.dart';

class TargetAccountChipSelectorUi extends StatelessWidget {
  final ServiceStockController controller;
  const TargetAccountChipSelectorUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final products = controller.customerProducts;
    final selectedProduct = controller.selectedProduct;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'رقم کس کھاتے میں ایڈجسٹ کرنی ہے؟',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Center(
                    child: Text('فعال قسط میں کٹوتی', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                  ),
                  selected: controller.accountType == 0,
                  selectedColor: const Color(0xFFCCFBF1),
                  onSelected: (_) => controller.setAccountType(0),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ChoiceChip(
                  label: const Center(
                    child: Text('نقد / دستی پیشگی کھاتہ', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                  ),
                  selected: controller.accountType == 1,
                  selectedColor: const Color(0xFFCCFBF1),
                  onSelected: (_) => controller.setAccountType(1),
                ),
              ),
            ],
          ),

          if (controller.accountType == 0) ...[
            const SizedBox(height: 10),
            if (products.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: const Text(
                  'اس کسٹمر کے نام پر کوئی فعال قسط موجود نہیں ہے۔ برائے مہربانی نقد کھاتہ منتخب کریں۔',
                  style: TextStyle(fontSize: 10.5, color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
                ),
              )
            else ...[
              const Text(
                'مطلوبہ موبائل فون کا پلان منتخب کریں:',
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<int>(
                initialValue: controller.selectedProductIndex,
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
                items: List.generate(
                  products.length,
                  (i) => DropdownMenuItem(
                    value: i,
                    child: Text(
                      '${products[i]['name']} (${products[i]['plan']}) - بقایا: Rs. ${controller.formatAmount(products[i]['remaining'] ?? 0)}',
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                onChanged: (v) => controller.setSelectedProductIndex(v ?? 0),
              ),
              const SizedBox(height: 8),
              if (selectedProduct != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: controller.isOverMaxLimit ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: controller.isOverMaxLimit ? const Color(0xFFFECACA) : const Color(0xFFBBF7D0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'اس کھاتے کی زیادہ سے زیادہ حد (بقایا):',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: controller.isOverMaxLimit ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                        ),
                      ),
                      Text(
                        'Rs. ${controller.formatAmount(controller.maxAllowedLimit)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: controller.isOverMaxLimit ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ],
      ),
    );
  }
}