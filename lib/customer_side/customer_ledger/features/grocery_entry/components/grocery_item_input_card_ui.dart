import 'package:flutter/material.dart';
import '../grocery_entry_controller.dart';
import '../services/grocery_catalog_service.dart';

class GroceryItemInputCardUi extends StatelessWidget {
  final GroceryEntryController controller;
  final VoidCallback onAdd;

  const GroceryItemInputCardUi({super.key, required this.controller, required this.onAdd});

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
          const Text('راشن آئٹم کا نام (AutoComplete):', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
          const SizedBox(height: 6),
          Autocomplete<Map<String, dynamic>>(
            optionsBuilder: (textVal) => GroceryCatalogService.search(textVal.text),
            displayStringForOption: (opt) => opt['name'].toString(),
            onSelected: (opt) {
              controller.nameCtrl.text = opt['name'].toString();
              controller.rateCtrl.text = opt['rate'].toString();
            },
            fieldViewBuilder: (ctx, textCtrl, focusNode, _) {
              controller.nameCtrl.addListener(() {
                if (textCtrl.text != controller.nameCtrl.text) {
                  textCtrl.text = controller.nameCtrl.text;
                }
              });
              return TextField(
                controller: textCtrl,
                focusNode: focusNode,
                onChanged: (val) => controller.nameCtrl.text = val,
                decoration: const InputDecoration(
                  hintText: 'نام لکھیں (مثلاً چینی، گھی، آٹا)',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('مقدار / تعداد:', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 16),
                            onPressed: () => controller.stepQuantity(-1),
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller.qtyCtrl,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 16),
                            onPressed: () => controller.stepQuantity(1),
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ریٹ فی اکائی:', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: controller.rateCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: 'Rs. ',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
              label: const Text('بل میں شامل کریں (+)', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
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