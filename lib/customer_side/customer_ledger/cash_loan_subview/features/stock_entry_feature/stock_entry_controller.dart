import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/payload_services/stock_entry_payload_service.dart';

enum StockCategoryType {
  mobile('موبائل فون'),
  general('دیگر / جنرل الیکٹرانکس');

  final String label;
  const StockCategoryType(this.label);
}

class StockEntryController extends ChangeNotifier {
  final String customerPhone;
  StockEntryController({required this.customerPhone});

  StockCategoryType selectedCategory = StockCategoryType.mobile;

  // ٹیکسٹ کنٹرولرز
  final modelCtrl = TextEditingController();
  final purchasePriceCtrl = TextEditingController();
  final salePriceCtrl = TextEditingController();
  final imeiCtrl = TextEditingController();
  final generalSpecsCtrl = TextEditingController();

  // ڈراپ ڈاؤن لسٹیں اور منتخب ویلیوز
  String selectedRamRom = '4/64';
  final List<String> ramRomOptions = const [
    '2/32', '3/32', '4/64', '4/128', '6/128', '8/128', '8/256', '12/256'
  ];

  String selectedColor = 'Black';
  final List<String> colorOptions = const [
    'Black', 'Blue', 'Green', 'Silver', 'Gold', 'White', 'Other'
  ];

  String selectedConditionType = 'USED';
  String selectedConditionRating = '10/10';
  final List<String> conditionRatings = const [
    '10/10', '9.5/10', '9/10', '8.5/10', '8/10', '7/10'
  ];

  String selectedWarranty = 'No Warranty';
  final List<String> warrantyOptions = [
    'No Warranty',
    'Check Warranty (3 Days)',
    ...List.generate(12, (i) => 'Official Warranty (${i + 1} Month${i == 0 ? '' : 's'})'),
  ];

  bool isPromotionalOnOrder = false;
  List<String> images = [];

  bool get isMobile => selectedCategory == StockCategoryType.mobile;

  // مختصر سیٹرز تاکہ UI میں ایرر نہ آئے
  void setCategory(StockCategoryType val) { selectedCategory = val; notifyListeners(); }
  void setRamRom(String val) { selectedRamRom = val; notifyListeners(); }
  void setColor(String val) { selectedColor = val; notifyListeners(); }
  void setConditionType(String val) { selectedConditionType = val; notifyListeners(); }
  void setConditionRating(String val) { selectedConditionRating = val; notifyListeners(); }
  void setWarranty(String val) { selectedWarranty = val; notifyListeners(); }
  void toggleMode(bool val) { isPromotionalOnOrder = val; notifyListeners(); }
  void addMockImage(String path) { images.add(path); notifyListeners(); }
  void removeImageByPath(String path) { images.remove(path); notifyListeners(); }

  Future<bool> submitEntry() async {
    final purchase = int.tryParse(purchasePriceCtrl.text.trim()) ?? 0;
    final sale = double.tryParse(salePriceCtrl.text.trim()) ?? 0.0;
    final title = modelCtrl.text.trim();

    if (title.isEmpty || sale <= 0) return false;

    await StockEntryPayloadService.saveStockEntry(
      customerPhone: customerPhone,
      category: selectedCategory.name,
      model: title,
      ramRom: isMobile ? selectedRamRom : '',
      color: isMobile ? selectedColor : '',
      conditionType: isMobile ? selectedConditionType : 'NEW',
      conditionRating: isMobile ? selectedConditionRating : 'Brand New',
      imeiNo: isMobile ? imeiCtrl.text.trim() : '',
      warranty: isMobile ? selectedWarranty : '',
      generalSpecs: isMobile ? '' : generalSpecsCtrl.text.trim(),
      purchasePrice: purchase,
      salePrice: sale,
      isPromotionalOnOrder: isPromotionalOnOrder,
      images: images,
    );
    return true;
  }

  @override
  void dispose() {
    modelCtrl.dispose();
    purchasePriceCtrl.dispose();
    salePriceCtrl.dispose();
    imeiCtrl.dispose();
    generalSpecsCtrl.dispose();
    super.dispose();
  }
}