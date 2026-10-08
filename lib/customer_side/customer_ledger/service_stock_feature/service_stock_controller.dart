import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/services/grocery_entry_service.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/services/supplier_mobile_service.dart';

class ServiceStockController extends ChangeNotifier {
  final String customerPhone;
  final List<Map<String, dynamic>> customerProducts;

  final groceryService = GroceryEntryService();
  final mobileService = SupplierMobileService();

  int mainMode = 0; // 0 = راشن، 1 = موبائل
  int accountType = 0; // 0 = فعال قسط، 1 = نقد/پیشگی
  int selectedProductIndex = 0;
  int mobileIntent = 1; // 0 = فوری فروخت، 1 = پروموشنل

  final noteCtrl = TextEditingController();
  bool hasPhoto = false;
  bool hasAudio = false;

  Timer? _stepperTimer;

  ServiceStockController({
    this.customerPhone = '',
    this.customerProducts = const [],
  });

  bool get isMobileSupplierMode => mainMode == 1;
  int get groceryTotal => groceryService.groceryTotal;
  int get mobileTotal => mobileService.mobileTotal;
  int get totalBill => isMobileSupplierMode ? mobileTotal : groceryTotal;

  Map<String, dynamic>? get selectedProduct {
    if (customerProducts.isNotEmpty && selectedProductIndex < customerProducts.length) {
      return customerProducts[selectedProductIndex];
    }
    return null;
  }

  // 🎯 منتخب شدہ موبائل کا کل بقایا (میکس لمٹ)
  int get maxAllowedLimit {
    if (accountType == 0 && selectedProduct != null) {
      return (selectedProduct!['remaining'] as int?) ?? 0;
    }
    return 99999999;
  }

  // 🎯 کیا راشن کا بل میکس حد سے تجاوز کر گیا ہے؟
  bool get isOverMaxLimit {
    if (accountType == 0 && selectedProduct != null) {
      return groceryTotal > maxAllowedLimit;
    }
    return false;
  }

  String formatAmount(num amount) {
    return amount.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  void setMainMode(int mode) {
    mainMode = mode;
    notifyListeners();
  }

  void setAccountType(int type) {
    accountType = type;
    notifyListeners();
  }

  void setSelectedProductIndex(int index) {
    selectedProductIndex = index;
    notifyListeners();
  }

  void setMobileIntent(int intent) {
    mobileIntent = intent;
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

  void selectAutocompleteItem(String val) {
    groceryService.selectAutocompleteItem(val);
    notifyListeners();
  }

  void incrementQty() {
    groceryService.incrementQty();
    notifyListeners();
  }

  void decrementQty() {
    groceryService.decrementQty();
    notifyListeners();
  }

  void incrementPrice() {
    groceryService.incrementPrice();
    notifyListeners();
  }

  void decrementPrice() {
    groceryService.decrementPrice();
    notifyListeners();
  }

  void setManualPrice(String text) {
    groceryService.setManualPrice(text);
    notifyListeners();
  }

  void addGroceryItem() {
    if (groceryService.addGroceryItem()) {
      notifyListeners();
    }
  }

  void removeGroceryItem(int index) {
    groceryService.removeGroceryItem(index);
    notifyListeners();
  }

  void startFastStepper({required VoidCallback onTick}) {
    onTick();
    _stepperTimer?.cancel();
    _stepperTimer = Timer.periodic(const Duration(milliseconds: 70), (_) {
      onTick();
    });
  }

  void stopFastStepper() {
    _stepperTimer?.cancel();
  }

  void setColor(String val) {
    mobileService.selectedColor = val;
    notifyListeners();
  }

  void setConditionType(String val) {
    mobileService.selectedConditionType = val;
    notifyListeners();
  }

  void setConditionRating(String val) {
    mobileService.selectedConditionRating = val;
    notifyListeners();
  }

  void setRamRom(String val) {
    mobileService.selectedRamRom = val;
    notifyListeners();
  }

  void setWarranty(String val) {
    mobileService.selectedWarranty = val;
    notifyListeners();
  }

  bool addSupplierMobile() {
    final ok = mobileService.addSupplierMobile(mobileIntent: mobileIntent);
    if (ok) notifyListeners();
    return ok;
  }

  void removeSupplierMobile(int index) {
    mobileService.removeSupplierMobile(index);
    notifyListeners();
  }

  @override
  void dispose() {
    _stepperTimer?.cancel();
    noteCtrl.dispose();
    groceryService.dispose();
    mobileService.dispose();
    super.dispose();
  }
}