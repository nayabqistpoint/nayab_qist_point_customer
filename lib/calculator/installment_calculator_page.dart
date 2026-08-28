import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🎯 سٹرکچر کے مطابق ڈائریکٹ shared فولڈر کے امپورٹ پاتھس:
import 'package:nayab_qist_point_customer/calculator/calculator_controller.dart'; 
import 'package:nayab_qist_point_customer/calculator/calculator_header.dart';
import 'package:nayab_qist_point_customer/calculator/calculator_list.dart';

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
    // یہاں Provider کو لپیٹنا (Wrap) ضروری ہے تاکہ ڈیٹا کنٹرولر تک پہنچے
    return ChangeNotifierProvider(
      create: (context) => CalculaterController(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CalculaterHeader(
                onDataChanged: (data) {
                  setState(() {
                    _headerData = data;
                  });
                },
              ), 
              Expanded(
                child: CalculaterList(
                  onPackageSelected: (selectedItem) {
                    // اب ہیڈر اور لسٹ دونوں کا ڈیٹا مل کر واپس جائے گا
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