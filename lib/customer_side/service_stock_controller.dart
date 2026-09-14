import 'package:flutter/material.dart';

class ServiceStockController extends ChangeNotifier {
  final List<String> targetAccounts;

  ServiceStockController({required this.targetAccounts}) {
    target = targetAccounts.isNotEmpty
        ? targetAccounts.first
        : 'نیا / آزاد کسٹمر کریڈٹ کھاتہ';
  }

  // 🎯 ٹیکسٹ کنٹرولرز
  final titleCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  final itemNameCtrl = TextEditingController();
  final itemAmountCtrl = TextEditingController();
  final mobileModelCtrl = TextEditingController();
  final mobilePriceCtrl = TextEditingController();
  final imeiCtrl = TextEditingController();

  // 🎯 اسمارٹ ڈراپ ڈاؤن ڈیفالٹس
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

  bool hasPhoto = false;
  bool hasAudio = false;

  int selectedNatureIndex = 0; // 0 = راشن، 1 = موبائل اسٹاک
  late String target;

  List<Map<String, dynamic>> groceryList = [
    {'name': 'چینی (5 کلو)', 'amount': 750},
  ];
  List<Map<String, dynamic>> mobileStockList = [];

  final List<String> configExpenseCategories = [
    'گھریلو راشن و گروسری (ڈائریکٹ ایکسپنس)',
    'دکان چائے پانی / اخراجات (ان ڈائریکٹ ایکسپنس)',
    'رعایت / خصوصی ڈسکاؤنٹ (ڈائریکٹ ایکسپنس)',
    'دکان مرمت و سروس ورکشاپ (ان ڈائریکٹ ایکسپنس)',
    'دیگر متفرق اخراجات (General Expense)',
  ];

  List<Map<String, dynamic>> expenseAllocations = [
    {'category': 'گھریلو راشن و گروسری (ڈائریکٹ ایکسپنس)', 'amount': 750},
  ];

  // 🎯 کیلکولیشنز
  bool get isStockBarter => selectedNatureIndex == 1;

  int get totalBill {
    return isStockBarter
        ? mobileStockList.fold(0, (sum, i) => sum + (i['amount'] as int))
        : groceryList.fold(0, (sum, i) => sum + (i['amount'] as int));
  }

  int get expenseSum =>
      expenseAllocations.fold(0, (sum, e) => sum + ((e['amount'] as int?) ?? 0));

  int get expenseDifference => expenseSum - totalBill;

  bool get isExpenseReconciled =>
      isStockBarter || (expenseDifference == 0 && totalBill > 0);

  String formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  // 🎯 اسٹیٹ تبدیل کرنے والے طریقے
  void setNatureIndex(int index) {
    selectedNatureIndex = index;
    if (index == 0) {
      int tBill = groceryList.fold(0, (sum, i) => sum + (i['amount'] as int));
      if (expenseAllocations.isNotEmpty) {
        expenseAllocations[0]['amount'] = tBill;
      }
    }
    notifyListeners();
  }

  void setTarget(String val) {
    target = val;
    notifyListeners();
  }

  void togglePhoto() {
    hasPhoto = !hasPhoto;
    notifyListeners();
  }

  void toggleAudio() {
    hasAudio = !hasAudio;
    notifyListeners();
  }

  void setRamRom(String val) {
    selectedRamRom = val;
    notifyListeners();
  }

  void setCondition(String val) {
    mobileCondition = val;
    notifyListeners();
  }

  void setWarranty(String val) {
    selectedWarranty = val;
    notifyListeners();
  }

  // 🎯 گروسری ہینڈلنگ
  void addGroceryItem() {
    if (itemNameCtrl.text.isNotEmpty && itemAmountCtrl.text.isNotEmpty) {
      groceryList.add({
        'name': itemNameCtrl.text.trim(),
        'amount': int.tryParse(itemAmountCtrl.text.trim().replaceAll(',', '')) ?? 0,
      });
      itemNameCtrl.clear();
      itemAmountCtrl.clear();
      int newT = groceryList.fold(0, (s, i) => s + (i['amount'] as int));
      if (expenseAllocations.isNotEmpty) {
        expenseAllocations[0]['amount'] = newT;
      }
      notifyListeners();
    }
  }

  void removeGroceryItem(int index) {
    groceryList.removeAt(index);
    int newT = groceryList.fold(0, (s, i) => s + (i['amount'] as int));
    if (expenseAllocations.isNotEmpty) {
      expenseAllocations[0]['amount'] = newT;
    }
    notifyListeners();
  }

  // 🎯 ایکسپنس ہینڈلنگ
  void addExpenseAllocation() {
    expenseAllocations.add({
      'category': configExpenseCategories[1],
      'amount': 0,
    });
    notifyListeners();
  }

  void updateExpenseCategory(int index, String category) {
    expenseAllocations[index]['category'] = category;
    notifyListeners();
  }

  void updateExpenseAmount(int index, String amountStr) {
    expenseAllocations[index]['amount'] = int.tryParse(amountStr) ?? 0;
    notifyListeners();
  }

  void removeExpenseAllocation(int index) {
    expenseAllocations.removeAt(index);
    notifyListeners();
  }

  // 🎯 موبائل اسٹاک ہینڈلنگ
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
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeMobileStock(int index) {
    mobileStockList.removeAt(index);
    notifyListeners();
  }

  Map<String, dynamic>? getSubmitPayload() {
    final List<Map<String, dynamic>> finalItems =
        isStockBarter ? List.from(mobileStockList) : List.from(groceryList);

    if (finalItems.isEmpty) return null;

    return {
      'title': titleCtrl.text.isEmpty
          ? (isStockBarter ? 'موبائل اسٹاک تبادلہ' : 'راشن و گروسری بل')
          : titleCtrl.text.trim(),
      'nature': isStockBarter ? 'STOCK' : 'EXPENSE',
      'natureTitle': isStockBarter ? 'اسٹاک تبادلہ (موبائل)' : 'دکان و راشن خرچہ',
      'isExpanded': false,
      'syncStatus': 'FIRESTORE_PUSHED',
      'items': finalItems,
      'expenseAllocations': isStockBarter ? [] : List.from(expenseAllocations),
      'totalAmount': totalBill,
      'target': target,
      'hasAudio': hasAudio,
      'hasPhoto': hasPhoto,
      'date': 'آج',
    };
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    noteCtrl.dispose();
    itemNameCtrl.dispose();
    itemAmountCtrl.dispose();
    mobileModelCtrl.dispose();
    mobilePriceCtrl.dispose();
    imeiCtrl.dispose();
    super.dispose();
  }
}