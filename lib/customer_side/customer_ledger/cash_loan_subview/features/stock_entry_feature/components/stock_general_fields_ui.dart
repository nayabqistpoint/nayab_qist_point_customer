import 'package:flutter/material.dart';
import '../stock_entry_controller.dart';

class StockGeneralFieldsUi extends StatelessWidget {
  final StockEntryController controller;

  const StockGeneralFieldsUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller.generalSpecsCtrl, // 👈 یہاں generalSpecsController کے بجائے generalSpecsCtrl آئے گا
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'سامان کی تفصیل و نمایاں خصوصیات',
            hintText: 'مثلاً: 56 انچ تانبا وائنڈنگ، 2 سال وارنٹی، یا 9 کلو گرام واشنگ مشین',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.description_outlined),
          ),
        ),
      ],
    );
  }
}