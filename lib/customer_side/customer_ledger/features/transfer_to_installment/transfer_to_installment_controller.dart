import 'package:flutter/material.dart';
import 'transfer_to_installment_args.dart';
import 'services/transfer_storage_handler.dart';
import 'services/transfer_to_installment_service.dart';

class TransferToInstallmentController extends ChangeNotifier {
  final TransferToInstallmentArgs args;
  int selectedIndex = 0;
  bool isSubmitting = false;
  final TextEditingController amountCtrl = TextEditingController();

  TransferToInstallmentController({required this.args});

  String get customerPhone => args.customerPhone;
  List<Map<String, dynamic>> get products => args.products;
  int get availableGreenAdvance => args.availableGreenAdvance;

  Map<String, dynamic>? get currentProduct =>
      products.isNotEmpty && selectedIndex < products.length ? products[selectedIndex] : null;

  int get maxRemaining => (currentProduct?['remaining'] as int?) ?? 0;
  bool get hasPendingReview => currentProduct?['hasPendingReview'] == true;

  int get maxAllowed => TransferToInstallmentService.calculateMaxAllowed(
        availableGreenAdvance: availableGreenAdvance,
        maxRemaining: maxRemaining,
      );

  int get parsedAmount =>
      int.tryParse(amountCtrl.text.trim().replaceAll(',', '')) ?? 0;

  void selectProduct(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  String? validate() {
    return TransferToInstallmentService.validateTransferAmount(
      amount: parsedAmount,
      maxRemaining: maxRemaining,
      availableGreenAdvance: availableGreenAdvance,
    );
  }

  Future<TransferToInstallmentResult> submitTransfer() async {
    final validationError = validate();
    if (validationError != null || currentProduct == null) {
      return const TransferToInstallmentResult(isSuccess: false, transferredAmount: 0);
    }

    isSubmitting = true;
    notifyListeners();

    final contractDocId = (currentProduct!['docId'] ?? '').toString();
    final productName = (currentProduct!['title'] ?? currentProduct!['name'] ?? 'پروڈکٹ').toString();
    final int transferAmount = parsedAmount;

    final success = await TransferStorageHandler.executeTransfer(
      customerPhone: customerPhone,
      contractDocId: contractDocId,
      productName: productName,
      transferAmount: transferAmount,
    );

    isSubmitting = false;
    notifyListeners();

    return TransferToInstallmentResult(
      isSuccess: success,
      transferredAmount: success ? transferAmount : 0,
    );
  }

  String formatAmount(int amount) => TransferToInstallmentService.formatAmount(amount);

  @override
  void dispose() {
    amountCtrl.dispose();
    super.dispose();
  }
}