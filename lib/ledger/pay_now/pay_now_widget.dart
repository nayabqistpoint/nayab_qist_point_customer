import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:nayab_qist_point_customer/ledger/pay_now/pay_now_controller.dart';
import 'package:nayab_qist_point_customer/shared_widgets/payment_source_card.dart';
import 'package:nayab_qist_point_customer/shared_widgets/discount_widget.dart';
import 'package:nayab_qist_point_customer/shared_widgets/audio_record_player_widget.dart'; // 🎯 پاتھ کو بالکل درست کر دیا گیا ہے

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
  late final PayNowController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PayNowController();
    _controller.initialize(
      mobileNumber: widget.customerMobileNumber,
      initialAmount: widget.initialAmount,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    final errorMessage = _controller.validateForm();
    if (errorMessage != null) {
      _showRtlSnackBar(errorMessage);
      return;
    }

    bool success = await _controller.submitTransaction();

    if (mounted && success) {
      _controller.clearForm();
      _showRtlSnackBar("قسط کی درخواست کامیابی سے جمع ہو گئی ہے!", isError: false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          final data = snapshot.data?.data() as Map<String, dynamic>?;
          final availableBanks = _extractList(data, 'availableBanks', 'Cash');
          final discountCategories = _extractList(data, 'discountCategories', 'Discounts');

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAmountInputField(),
                      const SizedBox(height: 12),
                      ListenableBuilder(
                        listenable: _controller,
                        builder: (context, child) {
                          if (_controller.enteredAmount <= 0) return const SizedBox.shrink();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: AudioRecordPlayerWidget(
                                  onAudioChanged: (audioPath) {
                                    _controller.audioPath = audioPath;
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              DiscountWidget(
                                categories: discountCategories,
                                onDiscountChanged: (categoryName, discountValue, isPercentage) {
                                  _controller.updateDiscount(
                                    category: categoryName,
                                    value: discountValue,
                                    isPercentage: isPercentage,
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              PaymentSourceCard(
                                controller: _controller,
                                availableBanks: availableBanks,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              _buildSaveButton(),
            ],
          );
        },
      ),
    );
  }

  List<String> _extractList(Map<String, dynamic>? data, String key, String defaultItem) {
    List<String> list = [defaultItem];
    if (data != null && data[key] is List) {
      list = (data[key] as List).map((e) => e.toString()).toList();
      if (!list.contains(defaultItem)) list.insert(0, defaultItem);
    }
    return list;
  }

  Widget _buildAmountInputField() {
    return SizedBox(
      height: 55,
      child: TextField(
        controller: _controller.amountController,
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
    );
  }

  Widget _buildSaveButton() {
    return Container(
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
    );
  }
}