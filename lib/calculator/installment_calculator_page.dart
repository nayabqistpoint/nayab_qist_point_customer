import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🎯 نئے ماڈیولر سٹرکچر کے امپورٹ پاتھس:
import 'package:nayab_qist_point_customer/calculator/calculator_controller.dart'; 
import 'package:nayab_qist_point_customer/calculator/calculator_header_ui.dart';
import 'package:nayab_qist_point_customer/calculator/calculator_list_ui.dart';

class InstallmentCalculaterPage extends StatefulWidget {
  const InstallmentCalculaterPage({super.key});

  @override
  State<InstallmentCalculaterPage> createState() => _InstallmentCalculaterPageState();
}

class _InstallmentCalculaterPageState extends State<InstallmentCalculaterPage> {
  // ہیڈر سے آنے والا ڈیٹا یہاں محفوظ رہے گا
  Map<String, dynamic> _headerData = {};

  @override
  Widget build(BuildContext context) {
    // 🎯 Provider یہاں کنٹرولر کی اسٹیٹ سنبھالے گا
    return ChangeNotifierProvider(
      create: (context) => CalculaterController(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // 🟢 ہیڈر UI
              CalculaterHeaderUi(
                onDataChanged: (data) {
                  setState(() {
                    _headerData = data;
                  });
                },
              ), 
              // 🟢 اقساط کی لسٹ UI
              Expanded(
                child: CalculaterListUi(
                  onPackageSelected: (selectedItem) {
                    // ہیڈر اور لسٹ دونوں کا مشترکہ ڈیٹا تیار کر کے واپس بھیجنا
                    final Map<String, dynamic> finalPackageData = {
                      ..._headerData,
                      'packageName': selectedItem['packageName'],
                      'advanceAmount': selectedItem['advance'] ?? _headerData['advanceAmount'],
                      'monthlyInstallment': selectedItem['installment'],
                      'totalPrice': selectedItem['total'],
                      'isAdvance': selectedItem['isAdvance'] ?? false,
                    };
                    
                    Navigator.pop(context, finalPackageData);
                  },
                ),
              ), 
            ],
          ),
        ),
      ),
    );
  }
}