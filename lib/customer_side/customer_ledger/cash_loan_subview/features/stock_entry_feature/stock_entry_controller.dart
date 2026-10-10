import 'package:flutter/material.dart';

class StockEntryController extends ChangeNotifier {
  final String customerPhone;
  final TextEditingController modelCtrl = TextEditingController();
  final TextEditingController imeiCtrl = TextEditingController();
  final TextEditingController purchasePriceCtrl = TextEditingController();
  final TextEditingController salePriceCtrl = TextEditingController();

  String selectedRamRom = '8GB / 128GB';
  String selectedColor = 'بلیک (Black)';
  String selectedConditionType = 'used';
  String selectedConditionRating = '07/10';
  String selectedWarranty = '3 دن چیکنگ وارنٹی';

  bool isPromotionalOnOrder = false;
  final List<String> images = [];

  final List<String> ramRomOptions = [
    '2GB / 32GB', '3GB / 32GB', '4GB / 64GB', '4GB / 128GB',
    '6GB / 128GB', '8GB / 128GB', '8GB / 256GB', '12GB / 256GB', '12GB / 512GB',
  ];

  final List<String> colorOptions = [
    'بلیک (Black)', 'سلور (Silver)', 'بلیو (Blue)', 'وائٹ (White)', 'گولڈ (Gold)', 'گرین (Green)',
  ];

  final List<String> conditionRatings = [
    '01/10', '02/10', '03/10', '04/10', '05/10',
    '06/10', '07/10', '08/10', '09/10', '10/10 (ڈبہ پیک)',
  ];

  final List<String> warrantyOptions = [
    'کوئی وارنٹی نہیں', '3 دن چیکنگ وارنٹی', '1 ماہ وارنٹی', '2 ماہ وارنٹی',
    '3 ماہ وارنٹی', '6 ماہ وارنٹی', '10 ماہ وارنٹی', '12 ماہ (1 سال وارنٹی)',
  ];

  StockEntryController({required this.customerPhone});

  void toggleMode(bool val) {
    isPromotionalOnOrder = val;
    notifyListeners();
  }

  void addMockImage() {
    images.add('IMG_MOBILE_${DateTime.now().millisecondsSinceEpoch}.jpg');
    notifyListeners();
  }

  void removeImage(String img) {
    images.remove(img);
    notifyListeners();
  }

  @override
  void dispose() {
    modelCtrl.dispose();
    imeiCtrl.dispose();
    purchasePriceCtrl.dispose();
    salePriceCtrl.dispose();
    super.dispose();
  }
}