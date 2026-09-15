import 'package:flutter/material.dart';

class MobileStockService {
  final mobileModelCtrl = TextEditingController();
  final mobilePriceCtrl = TextEditingController();
  final imeiCtrl = TextEditingController();

  String selectedRamRom = '4GB / 64GB';
  String selectedWarranty = '3 دن چیکنگ وارنٹی';
  String mobileCondition = 'استعمال شدہ (Used)';

  final List<String> ramRomOptions = [
    '2GB / 32GB',
    '3GB / 32GB',
    '4GB / 64GB',
    '4GB / 128GB',
    '6GB / 128GB',
    '8GB / 128GB',
    '8GB / 256GB',
    '12GB / 256GB',
  ];

  final List<String> warrantyOptions = [
    'وارنٹی ختم (0 ماہ)',
    '3 دن چیکنگ وارنٹی',
    '1 ماہ دکان وارنٹی',
    '3 ماہ وارنٹی',
    '6 ماہ وارنٹی',
    '12 ماہ کمپنی وارنٹی',
  ];

  List<Map<String, dynamic>> mobileStockList = [];

  int get totalBill =>
      mobileStockList.fold(0, (sum, i) => sum + (i['amount'] as int));

  bool addMobileStock() {
    if (mobileModelCtrl.text.trim().isNotEmpty &&
        mobilePriceCtrl.text.trim().isNotEmpty) {
      mobileStockList.add({
        'name': mobileModelCtrl.text.trim(),
        'amount': int.tryParse(mobilePriceCtrl.text.trim().replaceAll(',', '')) ?? 0,
        'ramRom': selectedRamRom,
        'condition': mobileCondition,
        'imei': imeiCtrl.text.trim(),
        'warranty': selectedWarranty,
      });
      mobileModelCtrl.clear();
      mobilePriceCtrl.clear();
      imeiCtrl.clear();
      return true;
    }
    return false;
  }

  void removeMobileStock(int index) {
    mobileStockList.removeAt(index);
  }

  void dispose() {
    mobileModelCtrl.dispose();
    mobilePriceCtrl.dispose();
    imeiCtrl.dispose();
  }
}