import 'package:flutter/material.dart';
import '../stock_entry_controller.dart';

class StockSpecificationsCardUi extends StatelessWidget {
  final StockEntryController controller;

  const StockSpecificationsCardUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('موبائل برانڈ و ماڈل (itemName):', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
          const SizedBox(height: 6),
          TextField(
            controller: controller.modelCtrl,
            decoration: const InputDecoration(
              hintText: 'مثلاً Vivo Y20، Google Pixel 7A، Redmi Note 12',
              helperText: 'برانڈ اور مکمل ماڈل ایک ساتھ لکھیں',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ریم / روم (ramRom):', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      initialValue: controller.selectedRamRom,
                      isExpanded: true,
                      decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                      items: controller.ramRomOptions.map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 12)))).toList(),
                      onChanged: (v) => controller.selectedRamRom = v!,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('رنگ (color):', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      initialValue: controller.selectedColor,
                      isExpanded: true,
                      decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                      items: controller.colorOptions.map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 12)))).toList(),
                      onChanged: (v) => controller.selectedColor = v!,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('کنڈیشن قسم (conditionType):', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      initialValue: controller.selectedConditionType,
                      decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                      items: const [
                        DropdownMenuItem(value: 'used', child: Text('یوزڈ (Used)', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'new', child: Text('نیا (New / Box Pack)', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (v) => controller.selectedConditionType = v!,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ریٹنگ (conditionRating):', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      initialValue: controller.selectedConditionRating,
                      isExpanded: true,
                      decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                      items: controller.conditionRatings.map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 12)))).toList(),
                      onChanged: (v) => controller.selectedConditionRating = v!,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('IMEI نمبر (اختیاری):', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: controller.imeiCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: '15 ہندسوں کا IMEI',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('وارنٹی مدت (warranty):', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      initialValue: controller.selectedWarranty,
                      isExpanded: true,
                      decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                      items: controller.warrantyOptions.map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 11.5)))).toList(),
                      onChanged: (v) => controller.selectedWarranty = v!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}