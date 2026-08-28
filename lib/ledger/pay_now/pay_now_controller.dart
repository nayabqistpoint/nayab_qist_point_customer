import 'package:flutter/material.dart';

class PayNowController extends ChangeNotifier {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  double _enteredAmount = 0.0;
  double get enteredAmount => _enteredAmount;

  String customerMobileNumber = "";
  String? audioPath;
  String? attachmentPath;

  // 🎯 ڈسکاؤنٹ ویری ایبلز
  String discountCategory = 'Discounts';
  double discountValue = 0.0;
  bool isDiscountPercentage = false;

  PayNowController() {
    amountController.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    double val = double.tryParse(amountController.text) ?? 0.0;
    if (_enteredAmount != val) {
      _enteredAmount = val;
      notifyListeners();
    }
  }

  // 🎯 خالص ڈسکاؤنٹ رقم معلوم کرنے کا فنکشن
  double get calculatedDiscountAmount {
    if (discountValue <= 0) return 0.0;
    if (isDiscountPercentage) {
      return (_enteredAmount * discountValue) / 100;
    }
    return discountValue;
  }

  // 🎯 نیٹ رقم جو کسٹمر نے ادا کرنی ہے (رقم مائنس ڈسکاؤنٹ)
  double get netPayableAmount {
    double net = _enteredAmount - calculatedDiscountAmount;
    return net < 0 ? 0.0 : net;
  }

  // 🎯 پے لوڈ تیار کرنے کا فنکشن (currentDate کو اب شامل کر دیا گیا ہے)
  Map<String, dynamic> buildTransactionPayload({
    required String paymentSource,
    List<Map<String, dynamic>>? splitPaymentsList,
  }) {
    final String description = descriptionController.text.trim();
    final String currentDate = "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";

    return {
      'type': 'received',
      'customerPhone': customerMobileNumber,
      'customerId': customerMobileNumber,
      'enteredAmount': _enteredAmount,
      'discount': {
        'category': discountCategory,
        'value': discountValue,
        'isPercentage': isDiscountPercentage,
        'discountAmount': calculatedDiscountAmount,
      },
      'netAmount': netPayableAmount,
      'source': paymentSource,
      'splitPayments': splitPaymentsList ?? [],
      'description': description,
      'date': currentDate, // 🎯 currentDate اب استعمال ہو گئی ہے
      'picturePath': attachmentPath ?? '',
      'audioPath': audioPath ?? 'Not Recorded',
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'pending',
      'isApproved': false,
    };
  }

  void clearForm() {
    amountController.clear();
    descriptionController.clear();
    _enteredAmount = 0.0;
    discountValue = 0.0;
    discountCategory = 'Discounts';
    isDiscountPercentage = false;
    audioPath = null;
    attachmentPath = null;
    notifyListeners();
  }
}

final PayNowController payNowController = PayNowController();