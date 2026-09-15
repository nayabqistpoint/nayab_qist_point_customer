import 'package:flutter/material.dart';
import '../service_stock_controller.dart';

class MobileStockSectionUi extends StatelessWidget {
  final ServiceStockController controller;

  const MobileStockSectionUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'موبائل اسٹاک تبادلہ (ملٹیپل فونز):',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            Text(
              'کل فونز: ${controller.mobileStockList.length}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF0D9488), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (controller.mobileStockList.isNotEmpty) ...[
          ...controller.mobileStockList.asMap().entries.map((entry) {
            int mIdx = entry.key;
            var m = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.phone_android_rounded, size: 18, color: Color(0xFF0D9488)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${mIdx + 1}. ${m['name']} (${m['ramRom']})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('IMEI: ${m['imei'].isEmpty ? "درج نہیں" : m['imei']} | ${m['condition']} | ${m['warranty']}', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  Text('Rs. ${controller.formatAmount(m['amount'])}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFDC2626)),
                    onPressed: () => controller.removeMobileStock(mIdx),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
        ],

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.mobileStockList.isEmpty ? 'پہلا موبائل درج کریں:' : 'اگلا موبائل لسٹ میں جوڑیں:',
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.mobileModelCtrl,
                decoration: InputDecoration(
                  hintText: 'موبائل ماڈل (مثلاً Samsung A12, Vivo Y20)',
                  hintStyle: const TextStyle(fontSize: 11.5),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedRamRom,
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                          items: controller.ramRomOptions.map((r) => DropdownMenuItem(value: r, child: Text('ریم/روم: $r'))).toList(),
                          onChanged: (v) => controller.setRamRom(v!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: controller.mobilePriceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'طے شدہ قیمت',
                        hintStyle: const TextStyle(fontSize: 11.5),
                        prefixText: 'Rs. ',
                        prefixStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), border: Border.all(color: const Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(10)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.mobileCondition,
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                          items: const [
                            DropdownMenuItem(value: 'استعمال شدہ (Used)', child: Text('استعمال شدہ')),
                            DropdownMenuItem(value: 'نیا ڈبہ پیک (Pin Pack)', child: Text('نیا ڈبہ پیک')),
                          ],
                          onChanged: (v) => controller.setCondition(v!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), border: Border.all(color: const Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(10)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedWarranty,
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                          items: controller.warrantyOptions.map((w) => DropdownMenuItem(value: w, child: Text(w, overflow: TextOverflow.ellipsis))).toList(),
                          onChanged: (v) => controller.setWarranty(v!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: controller.imeiCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '15 ہندسوں کا IMEI نمبر (اختیاری)',
                  hintStyle: const TextStyle(fontSize: 11.5),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    bool added = controller.addMobileStock();
                    if (!added) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('برائے مہربانی موبائل ماڈل اور قیمت درج کریں!'),
                          backgroundColor: Color(0xFFDC2626),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('پلس موبائل لسٹ میں جوڑیں', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}