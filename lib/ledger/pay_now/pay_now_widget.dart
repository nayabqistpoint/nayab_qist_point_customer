import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:nayab_qist_point_customer/ledger/pay_now/pay_now_body.dart';
import 'package:nayab_qist_point_customer/ledger/pay_now/pay_now_controller.dart';
import 'package:nayab_qist_point_customer/shared_widgets/payment_source_card.dart';
import 'package:nayab_qist_point_customer/shared_widgets/discount_widget.dart';
import 'package:nayab_qist_point_customer/services/pay_now_sync_service.dart';

class PayNowWidget extends StatefulWidget {
  final String customerMobileNumber;
  final double? initialAmount;

  const PayNowWidget({
    super.key,
    required this.customerMobileNumber,
    this.initialAmount,
  });

  @override
  State<PayNowWidget> createState() => _PayNowWidgetState();
}

class _PayNowWidgetState extends State<PayNowWidget> {
  final GlobalKey<PaymentSourceCardState> _paymentCardKey = GlobalKey<PaymentSourceCardState>();
  String selectedPaymentSource = 'Cash';

  @override
  void initState() {
    super.initState();
    if (widget.initialAmount != null && widget.initialAmount! > 0) {
      payNowController.amountController.text = widget.initialAmount!.toStringAsFixed(0);
    }
  }

  void _showRtlSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            message,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleSave() async {
    final cardState = _paymentCardKey.currentState;
    bool isSplit = cardState != null && cardState.isSplitMode;
    List<Map<String, dynamic>>? splitList = isSplit ? cardState.getSplitPaymentsList() : null;

    double netAmount = payNowController.netPayableAmount;
    double enteredPaymentTotal = cardState?.totalReceived ?? 0.0;

    if (payNowController.enteredAmount <= 0) {
      _showRtlSnackBar("برائے مہربانی قسط کی درست رقم درج کریں!");
      return;
    }

    if (enteredPaymentTotal != netAmount) {
      _showRtlSnackBar(
        "رقم کا حساب غلط ہے! ڈسکاؤنٹ نکال کر کل رقم Rs. ${netAmount.toStringAsFixed(0)} بنتی ہے، جبکہ آپ نے Rs. ${enteredPaymentTotal.toStringAsFixed(0)} درج کی ہے۔ برائے مہربانی برابر رقم درج کریں۔",
      );
      return;
    }

    final payload = payNowController.buildTransactionPayload(
      paymentSource: selectedPaymentSource,
      splitPaymentsList: splitList,
    );

    bool success = await SyncService.processAndUploadTransaction(payload);

    if (mounted && success) {
      payNowController.clearForm();
      _showRtlSnackBar("قسط کی درخواست کامیابی سے جمع ہو گئی ہے!", isError: false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    payNowController.customerMobileNumber = widget.customerMobileNumber;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("قسط ادا کریں", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text("نایاب قسط پوائنٹ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('settings').doc('app_config').snapshots(),
        builder: (context, snapshot) {
          List<String> availableBanks = ['Cash'];
          List<String> discountCategories = ['Discounts'];

          if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>?;
            if (data != null) {
              if (data['availableBanks'] is List) {
                availableBanks = (data['availableBanks'] as List).map((e) => e.toString()).toList();
              }
              if (data['discountCategories'] is List) {
                discountCategories = (data['discountCategories'] as List).map((e) => e.toString()).toList();
              }
            }
          }

          if (!availableBanks.contains('Cash')) availableBanks.insert(0, 'Cash');
          if (!discountCategories.contains('Discounts')) discountCategories.insert(0, 'Discounts');

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 55,
                        child: TextField(
                          controller: payNowController.amountController,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          decoration: InputDecoration(
                            hintText: "رقم درج کریں",
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "PKR",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 14),
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListenableBuilder(
                        listenable: payNowController,
                        builder: (context, child) {
                          if (payNowController.enteredAmount <= 0) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: const PayNowBody(),
                              ),
                              const SizedBox(height: 12),
                              DiscountWidget(
                                categories: discountCategories,
                                onDiscountChanged: (categoryName, discountValue, isPercentage) {
                                  payNowController.discountCategory = categoryName;
                                  payNowController.discountValue = discountValue;
                                  payNowController.isDiscountPercentage = isPercentage;
                                },
                              ),
                              const SizedBox(height: 12),
                              PaymentSourceCard(
                                key: _paymentCardKey,
                                availableBanks: availableBanks,
                                selectedSource: selectedPaymentSource,
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    setState(() => selectedPaymentSource = newValue);
                                  }
                                },
                                noteController: payNowController.descriptionController,
                                onAttachmentPicked: (path) {
                                  payNowController.attachmentPath = path;
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 5,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: _handleSave,
                    child: const Text(
                      "محفوظ کریں",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}