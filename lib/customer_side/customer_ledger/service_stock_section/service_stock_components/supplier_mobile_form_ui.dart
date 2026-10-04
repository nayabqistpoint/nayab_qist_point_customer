import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_section/service_stock_controller.dart';

class SupplierMobileFormUi extends StatelessWidget {
  final ServiceStockController controller;
  const SupplierMobileFormUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final mService = controller.mobileService;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: mService.mobileModelCtrl,
            decoration: InputDecoration(
              labelText: 'موبائل ماڈل کا نام (itemName)',
              labelStyle: const TextStyle(fontSize: 11),
              hintText: 'Google Pixel 7A, Vivo Y20',
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: mService.selectedColor,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'رنگ (color)',
                    labelStyle: const TextStyle(fontSize: 10.5),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: mService.colorOptions
                      .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 11))))
                      .toList(),
                  onChanged: (v) => controller.setColor(v!),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: mService.selectedConditionType,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'حالت (conditionType)',
                    labelStyle: const TextStyle(fontSize: 10.5),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'used', child: Text('استعمال شدہ (used)', style: TextStyle(fontSize: 11))),
                    DropdownMenuItem(value: 'new', child: Text('نیا ڈبہ پیک (new)', style: TextStyle(fontSize: 11))),
                  ],
                  onChanged: (v) => controller.setConditionType(v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: mService.selectedConditionRating,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'ریٹنگ (conditionRating)',
                    labelStyle: const TextStyle(fontSize: 10.5),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: mService.ratingOptions
                      .map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 11))))
                      .toList(),
                  onChanged: mService.selectedConditionType == 'new' ? null : (v) => controller.setConditionRating(v!),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: mService.selectedRamRom,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'ریم و روم (ramRom)',
                    labelStyle: const TextStyle(fontSize: 10.5),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: mService.ramRomOptions
                      .map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 11))))
                      .toList(),
                  onChanged: (v) => controller.setRamRom(v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: mService.purchasePriceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'خریداری لاگت (purchasePrice)',
                    labelStyle: const TextStyle(fontSize: 10, color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
                    prefixText: 'Rs. ',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: mService.salePriceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'فروخت / انوائس ریٹ (salePrice)',
                    labelStyle: const TextStyle(fontSize: 10, color: Color(0xFF0D9488), fontWeight: FontWeight.bold),
                    prefixText: 'Rs. ',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: mService.selectedWarranty,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'وارنٹی (warranty)',
                    labelStyle: const TextStyle(fontSize: 10.5),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: mService.warrantyOptions
                      .map((w) => DropdownMenuItem(value: w, child: Text(w, style: const TextStyle(fontSize: 10.5))))
                      .toList(),
                  onChanged: (v) => controller.setWarranty(v!),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: mService.imeiNoCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '15 ہندسوں کا IMEI (اختیاری)',
                    labelStyle: const TextStyle(fontSize: 10),
                    hintText: '353617355443023',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                bool ok = controller.addSupplierMobile();
                if (!ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ماڈل کا نام اور خریداری قیمت درج کرنا لازمی ہے')),
                  );
                }
              },
              icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
              label: const Text('یہ موبائل لسٹ میں جوڑیں', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}