import 'package:flutter/material.dart';
import '../stock_entry_controller.dart';

class StockSpecificationsCardUi extends StatelessWidget {
  final StockEntryController controller;
  const StockSpecificationsCardUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('موبائل کی تفصیلات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),

            // ماڈل نام
            TextField(
              controller: controller.modelCtrl,
              decoration: InputDecoration(
                labelText: 'موبائل ماڈل / نام',
                hintText: 'مثلاً: Samsung Galaxy A15',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.phone_android),
              ),
            ),
            const SizedBox(height: 12),

            // ریم/روم اور رنگ
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: controller.ramRomOptions.contains(controller.selectedRamRom)
                        ? controller.selectedRamRom
                        : controller.ramRomOptions.first,
                    decoration: InputDecoration(
                      labelText: 'ریم / روم',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: controller.ramRomOptions.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (v) { if (v != null) controller.setRamRom(v); },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: controller.colorOptions.contains(controller.selectedColor)
                        ? controller.selectedColor
                        : controller.colorOptions.first,
                    decoration: InputDecoration(
                      labelText: 'رنگ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: controller.colorOptions.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (v) { if (v != null) controller.setColor(v); },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // حالت (ڈبہ پیک یا استعمال شدہ)
            DropdownButtonFormField<String>(
              initialValue: (controller.selectedConditionType == 'USED' || controller.selectedConditionType == 'NEW')
                  ? controller.selectedConditionType
                  : 'USED',
              decoration: InputDecoration(
                labelText: 'حالت (Condition)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: const [
                DropdownMenuItem(value: 'NEW', child: Text('نیا (Brand New / ڈبہ پیک)')),
                DropdownMenuItem(value: 'USED', child: Text('استعمال شدہ (Used)')),
              ],
              onChanged: (v) { if (v != null) controller.setConditionType(v); },
            ),
            const SizedBox(height: 12),

            // کنڈیشن ریٹنگ
            DropdownButtonFormField<String>(
              initialValue: controller.conditionRatings.contains(controller.selectedConditionRating)
                  ? controller.selectedConditionRating
                  : controller.conditionRatings.first,
              decoration: InputDecoration(
                labelText: 'کنڈیشن ریٹنگ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: controller.conditionRatings.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) { if (v != null) controller.setConditionRating(v); },
            ),
            const SizedBox(height: 12),

            // IMEI
            TextField(
              controller: controller.imeiCtrl,
              decoration: InputDecoration(
                labelText: 'IMEI نمبر',
                hintText: '15 ہندسوں کا کوڈ درج کریں',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.qr_code),
              ),
            ),
            const SizedBox(height: 12),

            // وارنٹی ڈراپ ڈاؤن (1 سے 12 ماہ تک مکمل لسٹ)
            DropdownButtonFormField<String>(
              initialValue: controller.warrantyOptions.contains(controller.selectedWarranty)
                  ? controller.selectedWarranty
                  : controller.warrantyOptions.first,
              decoration: InputDecoration(
                labelText: 'وارنٹی کی تفصیل',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: controller.warrantyOptions.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) { if (v != null) controller.setWarranty(v); },
            ),
          ],
        ),
      ),
    );
  }
}