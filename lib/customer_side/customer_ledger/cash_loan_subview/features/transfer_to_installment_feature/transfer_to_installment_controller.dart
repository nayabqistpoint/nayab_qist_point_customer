import 'package:flutter/material.dart';

class TransferToInstallmentController extends ChangeNotifier {
  final List<Map<String, dynamic>> products;
  int selectedIndex = 0;
  final TextEditingController amountCtrl = TextEditingController();

  TransferToInstallmentController({required this.products});

  Map<String, dynamic>? get currentProduct => products.isNotEmpty ? products[selectedIndex] : null;
  int get maxRemaining => (currentProduct?['remaining'] as int?) ?? 0;
  bool get hasPendingReview => currentProduct?['hasPendingReview'] == true;

  void selectProduct(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  String? validate() {
    final amt = int.tryParse(amountCtrl.text.trim().replaceAll(',', '')) ?? 0;
    if (amt <= 0) return 'برائے مہربانی درست رقم درج کریں';
    if (amt > maxRemaining) return 'رقم اس پلان کے کل بقایا سے زیادہ نہیں ہو سکتی';
    return null;
  }

  int get parsedAmount => int.tryParse(amountCtrl.text.trim().replaceAll(',', '')) ?? 0;

  @override
  void dispose() {
    amountCtrl.dispose();
    super.dispose();
  }
}