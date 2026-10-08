import 'dart:math';
import 'package:flutter/material.dart';

class SupplierMobileService {
  final mobileModelCtrl = TextEditingController();
  final purchasePriceCtrl = TextEditingController();
  final salePriceCtrl = TextEditingController();
  final imeiNoCtrl = TextEditingController();

  String selectedConditionType = 'used';
  String selectedConditionRating = '07/10';
  String selectedColor = 'بلیک (Black)';
  String selectedRamRom = '8GB / 128GB';
  String selectedWarranty = '3 دن چیکنگ وارنٹی';

  List<Map<String, dynamic>> supplierStockList = [];

  final List<String> colorOptions = [
    'بلیک (Black)', 'بلیو (Blue)', 'سلور / وائٹ (White)',
    'گولڈ (Gold)', 'گرین (Green)', 'گرے (Gray)'
  ];

  final List<String> ratingOptions = [
    '10/10', '09/10', '08/10', '07/10', '06/10', '05/10', '04/10'
  ];

  final List<String> ramRomOptions = [
    '3GB / 32GB', '4GB / 64GB', '4GB / 128GB',
    '6GB / 128GB', '8GB / 128GB', '8GB / 256GB', '12GB / 256GB'
  ];

  final List<String> warrantyOptions = [
    'کوئی وارنٹی نہیں (0 ماہ)',
    '3 دن چیکنگ وارنٹی',
    '1 ماہ وارنٹی',
    '2 ماہ وارنٹی',
    '3 ماہ دکان وارنٹی',
    '6 ماہ وارنٹی',
    '8 ماہ وارنٹی',
    '10 ماہ وارنٹی',
    '12 ماہ کمپنی وارنٹی',
  ];

  int get mobileTotal =>
      supplierStockList.fold(0, (sum, i) => sum + (i['purchasePrice'] as int));

  bool addSupplierMobile({required int mobileIntent}) {
    if (mobileModelCtrl.text.trim().isEmpty || purchasePriceCtrl.text.trim().isEmpty) {
      return false;
    }

    int purchase = int.tryParse(purchasePriceCtrl.text.trim().replaceAll(',', '')) ?? 0;
    double sale = double.tryParse(salePriceCtrl.text.trim().replaceAll(',', '')) ?? purchase.toDouble();
    String generatedItemId = 'STK-${100 + Random().nextInt(900)}';

    supplierStockList.add({
      'itemId': generatedItemId,
      'itemName': mobileModelCtrl.text.trim(),
      'color': selectedColor,
      'conditionType': selectedConditionType,
      'conditionRating': selectedConditionType == 'new' ? '10/10' : selectedConditionRating,
      'ramRom': selectedRamRom,
      'imeiNo': imeiNoCtrl.text.trim().isEmpty ? '353617355443023' : imeiNoCtrl.text.trim(),
      'purchasePrice': purchase,
      'salePrice': sale,
      'quantity': 1,
      'warranty': selectedWarranty,
      'images': '',
      'status': mobileIntent == 1 ? 'available_on_order' : 'available',
      'intent': mobileIntent == 1 ? 'PROMOTIONAL_ON_ORDER' : 'DIRECT_SALE',
    });

    mobileModelCtrl.clear();
    purchasePriceCtrl.clear();
    salePriceCtrl.clear();
    imeiNoCtrl.clear();
    return true;
  }

  void removeSupplierMobile(int index) {
    supplierStockList.removeAt(index);
  }

  void dispose() {
    mobileModelCtrl.dispose();
    purchasePriceCtrl.dispose();
    salePriceCtrl.dispose();
    imeiNoCtrl.dispose();
  }
}