import 'package:flutter/material.dart';
import 'grocery_expense_service.dart';
import 'mobile_stock_service.dart';

class ServiceStockController extends ChangeNotifier {
  final List<String> targetAccounts;

  // 🎯 سروسز کی انیشیلائزیشن
  final groceryService = GroceryExpenseService();
  final mobileService = MobileStockService();

  // 🎯 گلوبل فیلڈز
  final titleCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  bool hasPhoto = false;
  bool hasAudio = false;
  int selectedNatureIndex = 0; // 0 = راشن، 1 = موبائل اسٹاک
  late String target;

  ServiceStockController({required this.targetAccounts}) {
    target = targetAccounts.isNotEmpty
        ? targetAccounts.first
        : 'نیا / آزاد کسٹمر کریڈٹ کھاتہ';
  }

  // 🎯 UI کمپوننٹس کے لیے فارورڈرز (تاکہ کوئی کمپوننٹ کوڈ تبدیل نہ کرنا پڑے)
  TextEditingController get itemNameCtrl => groceryService.itemNameCtrl;
  TextEditingController get itemAmountCtrl => groceryService.itemAmountCtrl;
  List<Map<String, dynamic>> get groceryList => groceryService.groceryList;
  List<String> get configExpenseCategories => groceryService.configExpenseCategories;
  List<Map<String, dynamic>> get expenseAllocations => groceryService.expenseAllocations;

  TextEditingController get mobileModelCtrl => mobileService.mobileModelCtrl;
  TextEditingController get mobilePriceCtrl => mobileService.mobilePriceCtrl;
  TextEditingController get imeiCtrl => mobileService.imeiCtrl;
  String get selectedRamRom => mobileService.selectedRamRom;
  String get selectedWarranty => mobileService.selectedWarranty;
  String get mobileCondition => mobileService.mobileCondition;
  List<String> get ramRomOptions => mobileService.ramRomOptions;
  List<String> get warrantyOptions => mobileService.warrantyOptions;
  List<Map<String, dynamic>> get mobileStockList => mobileService.mobileStockList;

  // 🎯 مجموعی کیلکولیشنز
  bool get isStockBarter => selectedNatureIndex == 1;
  int get totalBill => isStockBarter ? mobileService.totalBill : groceryService.totalBill;
  int get expenseSum => groceryService.expenseSum;
  int get expenseDifference => isStockBarter ? 0 : (groceryService.expenseSum - groceryService.totalBill);
  bool get isExpenseReconciled => isStockBarter || groceryService.isExpenseReconciled;

  String formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  // 🎯 ٹوگل اور فیلڈ ہینڈلرز
  void setNatureIndex(int index) {
    selectedNatureIndex = index;
    if (index == 0) groceryService.syncExpenseWithTotal();
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
    mobileService.selectedRamRom = val;
    notifyListeners();
  }

  void setCondition(String val) {
    mobileService.mobileCondition = val;
    notifyListeners();
  }

  void setWarranty(String val) {
    mobileService.selectedWarranty = val;
    notifyListeners();
  }

  // 🎯 گروسری ہینڈلرز
  void addGroceryItem() {
    groceryService.addGroceryItem();
    notifyListeners();
  }

  void removeGroceryItem(int index) {
    groceryService.removeGroceryItem(index);
    notifyListeners();
  }

  // 🎯 ایکسپنس ہینڈلرز
  void addExpenseAllocation() {
    groceryService.addExpenseAllocation();
    notifyListeners();
  }

  void updateExpenseCategory(int index, String category) {
    groceryService.updateExpenseCategory(index, category);
    notifyListeners();
  }

  void updateExpenseAmount(int index, String amountStr) {
    groceryService.updateExpenseAmount(index, amountStr);
    notifyListeners();
  }

  void removeExpenseAllocation(int index) {
    groceryService.removeExpenseAllocation(index);
    notifyListeners();
  }

  // 🎯 موبائل ہینڈلرز
  bool addMobileStock() {
    final ok = mobileService.addMobileStock();
    if (ok) notifyListeners();
    return ok;
  }

  void removeMobileStock(int index) {
    mobileService.removeMobileStock(index);
    notifyListeners();
  }

  // 🎯 حتمی سبمٹ پیلوڈ
  Map<String, dynamic>? getSubmitPayload() {
    final List<Map<String, dynamic>> finalItems =
        isStockBarter ? List.from(mobileService.mobileStockList) : List.from(groceryService.groceryList);

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
      'expenseAllocations': isStockBarter ? [] : List.from(groceryService.expenseAllocations),
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
    groceryService.dispose();
    mobileService.dispose();
    super.dispose();
  }
}