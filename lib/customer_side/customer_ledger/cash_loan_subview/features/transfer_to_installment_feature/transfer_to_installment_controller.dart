import 'package:flutter/material.dart';
import 'services/transfer_storage_handler.dart';

class TransferToInstallmentController extends ChangeNotifier {
  final String customerPhone;
  final List<Map<String, dynamic>> products;
  int selectedIndex = 0;
  final TextEditingController amountCtrl = TextEditingController();

  TransferToInstallmentController({
    required this.customerPhone,
    required this.products,
  });

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

  Future<bool> submitTransfer() async {
    final validationError = validate();
    if (validationError != null || currentProduct == null) return false;

    final contractDocId = (currentProduct!['docId'] ?? '').toString();
    final productName = (currentProduct!['title'] ?? currentProduct!['name'] ?? 'پروڈکٹ').toString();

    // پے لوڈ کا کوئی امپورٹ نہیں، سیدھا ہینڈلر کو کال
    return await TransferStorageHandler.executeTransfer(
      customerPhone: customerPhone,
      contractDocId: contractDocId,
      productName: productName,
      transferAmount: parsedAmount,
    );
  }

  @override
  void dispose() {
    amountCtrl.dispose();
    super.dispose();
  }
}