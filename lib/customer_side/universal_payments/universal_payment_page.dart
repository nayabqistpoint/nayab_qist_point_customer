// lib/customer_side/universal_payments/universal_payment_page.dart

import 'package:flutter/material.dart';
import 'universal_payment_controller.dart';
import 'universal_payment_components_ui/payment_app_bar_ui.dart';
import 'universal_payment_components_ui/payment_target_card_ui.dart';
import 'universal_payment_components_ui/payment_sources_split_card_ui.dart';
import 'universal_payment_components_ui/payment_adjustment_card_ui.dart';
import 'universal_payment_components_ui/payment_notes_media_card_ui.dart';
import 'universal_payment_components_ui/payment_footer_action_bar_ui.dart';

class UniversalPaymentPage extends StatefulWidget {
  final String title;
  final int baseAmount;
  final bool isInstallment;
  final String? itemName;
  final String? planTitle;
  final int? installmentNo;

  const UniversalPaymentPage({
    super.key,
    required this.title,
    required this.baseAmount,
    required this.isInstallment,
    this.itemName,
    this.planTitle,
    this.installmentNo,
  });

  @override
  State<UniversalPaymentPage> createState() => _UniversalPaymentPageState();
}

class _UniversalPaymentPageState extends State<UniversalPaymentPage> {
  late final UniversalPaymentController controller;

  @override
  void initState() {
    super.initState();
    controller = UniversalPaymentController(
      baseAmount: widget.baseAmount,
      isInstallment: widget.isInstallment,
      title: widget.title,
      itemName: widget.itemName,
      planTitle: widget.planTitle,
      installmentNo: widget.installmentNo,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: PaymentAppBarUi(title: widget.title),
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. کل رقم کا کارڈ
                  PaymentTargetCardUi(controller: controller),
                  const SizedBox(height: 14),

                  // 2. بینک اور کیش وصولی کارڈ (ٹاپ ترجیح)
                  PaymentSourcesSplitCardUi(
                    controller: controller,
                    onStateChange: controller.refresh,
                  ),
                  const SizedBox(height: 14),

                  // 3. اختیاری ڈسکاؤنٹ کلیم (معمول میں بند رہے گا)
                  PaymentAdjustmentCardUi(controller: controller),
                  const SizedBox(height: 14),

                  // 4. رسید تصویر اور آڈیو نوٹ
                  PaymentNotesMediaCardUi(controller: controller),
                  const SizedBox(height: 16),

                  // 5. فوٹر میزان و جمع بٹن
                  PaymentFooterActionBarUi(
                    controller: controller,
                    onSubmit: () => Navigator.pop(context, controller.buildSubmissionResult()),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}