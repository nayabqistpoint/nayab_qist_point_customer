import 'package:flutter/material.dart';

class GroceryEntryController extends ChangeNotifier {
  final String customerPhone;
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController qtyCtrl = TextEditingController(text: '1');
  final TextEditingController rateCtrl = TextEditingController();

  final List<Map<String, dynamic>> items = [];
  bool hasPhoto = false;
  bool hasAudio = false;

  GroceryEntryController({required this.customerPhone});

  int get grandTotal => items.fold(0, (sum, itm) => sum + ((itm['amount'] as num?)?.toInt() ?? 0));

  void stepQuantity(int delta) {
    int current = int.tryParse(qtyCtrl.text.trim()) ?? 1;
    current += delta;
    if (current < 1) current = 1;
    qtyCtrl.text = current.toString();
    notifyListeners();
  }

  bool addItem() {
    final name = nameCtrl.text.trim();
    final qty = int.tryParse(qtyCtrl.text.trim()) ?? 1;
    final rate = int.tryParse(rateCtrl.text.trim()) ?? 0;

    if (name.isEmpty || rate <= 0) return false;

    items.add({
      'name': name,
      'qty': '$qty اکائی',
      'rate': rate,
      'amount': rate * qty,
    });
    nameCtrl.clear();
    qtyCtrl.text = '1';
    rateCtrl.clear();
    notifyListeners();
    return true;
  }

  void togglePhoto(bool? val) {
    hasPhoto = val ?? false;
    notifyListeners();
  }

  void toggleAudio(bool? val) {
    hasAudio = val ?? false;
    notifyListeners();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    qtyCtrl.dispose();
    rateCtrl.dispose();
    super.dispose();
  }
}