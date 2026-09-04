import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/services/pay_now_sync_service.dart';
import 'package:nayab_qist_point_customer/services/pending_media_service.dart'; // 👈 نیا امپورٹ

class PaymentRowItem {
  String source;
  final TextEditingController amountController;

  PaymentRowItem({required this.source, String amount = ''})
      : amountController = TextEditingController(text: amount);
}

class PayNowController extends ChangeNotifier {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  double _enteredAmount = 0.0;
  double get enteredAmount => _enteredAmount;
  String customerMobileNumber = "";

  String? audioPath;
  String? attachmentPath;

  String discountCategory = 'Discounts';
  double discountValue = 0.0;
  bool isDiscountPercentage = false;

  String selectedPaymentSource = 'Cash';
  bool isSplitMode = false;
  final List<PaymentRowItem> splitRows = [];
  final TextEditingController singlePaymentAmountController = TextEditingController();

  PayNowController() {
    amountController.addListener(_onAmountChanged);
    singlePaymentAmountController.addListener(_onSinglePaymentAmountChanged);
  }

  void initialize({required String mobileNumber, double? initialAmount}) {
    customerMobileNumber = mobileNumber;
    if (initialAmount != null && initialAmount > 0) {
      amountController.text = initialAmount.toStringAsFixed(0);
    }
  }

  void _onAmountChanged() {
    double val = double.tryParse(amountController.text) ?? 0.0;
    if (_enteredAmount != val) {
      _enteredAmount = val;
      notifyListeners();
    }
  }

  void _onSinglePaymentAmountChanged() {
    notifyListeners();
  }

  void updateDiscount({
    required String category,
    required double value,
    required bool isPercentage,
  }) {
    discountCategory = category;
    discountValue = value;
    isDiscountPercentage = isPercentage;
    notifyListeners();
  }

  double get calculatedDiscountAmount {
    if (discountValue <= 0) return 0.0;
    if (isDiscountPercentage) {
      return (_enteredAmount * discountValue) / 100;
    }
    return discountValue;
  }

  double get netPayableAmount {
    double net = _enteredAmount - calculatedDiscountAmount;
    return net < 0 ? 0.0 : net;
  }

  double get totalReceivedAmount {
    if (isSplitMode) {
      return splitRows.fold(
        0.0,
        (total, item) => total + (double.tryParse(item.amountController.text) ?? 0.0),
      );
    } else {
      return double.tryParse(singlePaymentAmountController.text) ?? 0.0;
    }
  }

  void toggleSplitMode(List<String> sources) {
    isSplitMode = true;
    final String initialSingleText = singlePaymentAmountController.text;

    for (var r in splitRows) {
      r.amountController.removeListener(notifyListeners);
      r.amountController.dispose();
    }
    splitRows.clear();

    final String first = sources.contains(selectedPaymentSource) ? selectedPaymentSource : sources.first;
    final String second = sources.firstWhere((s) => s != first, orElse: () => sources.first);

    final item1 = PaymentRowItem(source: first, amount: initialSingleText);
    final item2 = PaymentRowItem(source: second);

    item1.amountController.addListener(notifyListeners);
    item2.amountController.addListener(notifyListeners);

    splitRows.addAll([item1, item2]);
    notifyListeners();
  }

  void addSplitRow(List<String> sources) {
    final String next = sources.firstWhere(
      (s) => !splitRows.any((r) => r.source == s),
      orElse: () => sources.first,
    );
    final newItem = PaymentRowItem(source: next);
    newItem.amountController.addListener(notifyListeners);
    splitRows.add(newItem);
    notifyListeners();
  }

  void removeSplitRow(int index) {
    splitRows[index].amountController.removeListener(notifyListeners);
    splitRows[index].amountController.dispose();
    splitRows.removeAt(index);
    if (splitRows.length <= 1) {
      isSplitMode = false;
      if (splitRows.isNotEmpty) {
        selectedPaymentSource = splitRows.first.source;
        singlePaymentAmountController.text = splitRows.first.amountController.text;
      }
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> getSplitPaymentsList() {
    if (!isSplitMode) return [];
    return splitRows
        .map((r) => {
              'source': r.source,
              'amount': double.tryParse(r.amountController.text) ?? 0.0,
            })
        .toList();
  }

  String? validateForm() {
    if (_enteredAmount <= 0) {
      return "برائے مہربانی قسط کی درست رقم درج کریں!";
    }

    final double net = netPayableAmount;
    final double received = totalReceivedAmount;

    if (received != net) {
      return "رقم کا حساب غلط ہے! ڈسکاؤنٹ نکال کر کل رقم Rs. ${net.toStringAsFixed(0)} بنتی ہے، جبکہ آپ نے Rs. ${received.toStringAsFixed(0)} درج کی ہے۔ برائے مہربانی برابر رقم درج کریں۔";
    }

    return null;
  }

  /// 🎯 فارم سبمٹ اور پینڈنگ میڈیا ٹریگر
  Future<bool> submitTransaction() async {
    bool isSuccess = await SyncService.processAndUploadTransaction(
      customerMobileNumber: customerMobileNumber,
      enteredAmount: _enteredAmount,
      netPayableAmount: netPayableAmount,
      selectedPaymentSource: selectedPaymentSource,
      discountCategory: discountCategory,
      discountValue: discountValue,
      isDiscountPercentage: isDiscountPercentage,
      calculatedDiscountAmount: calculatedDiscountAmount,
      splitPaymentsList: getSplitPaymentsList(),
      description: descriptionController.text.trim(),
      attachmentPath: attachmentPath,
      audioPath: audioPath,
    );

    if (isSuccess) {
      // 🎯 پینڈنگ میڈیا سروس کو فوراً ٹریگر کریں
      PendingMediaService.processPendingMedia();
    }

    return isSuccess;
  }

  void clearForm() {
    amountController.clear();
    descriptionController.clear();
    singlePaymentAmountController.clear();
    for (var r in splitRows) {
      r.amountController.removeListener(notifyListeners);
      r.amountController.dispose();
    }
    splitRows.clear();
    _enteredAmount = 0.0;
    discountValue = 0.0;
    discountCategory = 'Discounts';
    isDiscountPercentage = false;
    audioPath = null;
    attachmentPath = null;
    isSplitMode = false;
    notifyListeners();
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    singlePaymentAmountController.dispose();
    for (var r in splitRows) {
      r.amountController.removeListener(notifyListeners);
      r.amountController.dispose();
    }
    super.dispose();
  }
}