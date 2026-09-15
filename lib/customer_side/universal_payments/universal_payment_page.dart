import 'package:flutter/material.dart';
import 'universal_payment_controller.dart';
import 'universal_payment_components_ui/payment_app_bar_ui.dart';
import 'universal_payment_components_ui/payment_target_card_ui.dart';
import 'universal_payment_components_ui/payment_adjustment_card_ui.dart';
import 'universal_payment_components_ui/payment_sources_split_card_ui.dart';
import 'universal_payment_components_ui/payment_notes_media_card_ui.dart';
import 'universal_payment_components_ui/payment_footer_action_bar_ui.dart';

class UniversalPaymentPage extends StatefulWidget {
  final String title;
  final int baseAmount;
  final bool isInstallment;

  const UniversalPaymentPage({
    super.key,
    required this.title,
    required this.baseAmount,
    required this.isInstallment,
  });

  @override
  State<UniversalPaymentPage> createState() => _UniversalPaymentPageState();
}

class _UniversalPaymentPageState extends State<UniversalPaymentPage> {
  UniversalPaymentController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = UniversalPaymentController(
      baseAmount: widget.baseAmount,
      isInstallment: widget.isInstallment,
      title: widget.title,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ہاٹ ری لوڈ کے دوران محفوظ انیشیلائزیشن
    _controller ??= UniversalPaymentController(
      baseAmount: widget.baseAmount,
      isInstallment: widget.isInstallment,
      title: widget.title,
    );
    final controller = _controller!;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: PaymentAppBarUi(title: widget.title),
        body: SingleChildScrollView(
          // 👈 ہمیشہ سکرول اور قدرتی موبائل باؤنس
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaymentTargetCardUi(
                controller: controller,
                onStateChange: () => setState(() {}),
              ),
              const SizedBox(height: 14),
              PaymentAdjustmentCardUi(
                controller: controller,
                onStateChange: () => setState(() {}),
              ),
              const SizedBox(height: 16),
              PaymentSourcesSplitCardUi(
                controller: controller,
                onStateChange: () => setState(() {}),
              ),
              const SizedBox(height: 16),
              PaymentNotesMediaCardUi(
                controller: controller,
                onStateChange: () => setState(() {}),
              ),
              const SizedBox(height: 16),
              PaymentFooterActionBarUi(
                controller: controller,
                onSubmit: () => Navigator.pop(context, controller.buildSubmissionResult()),
              ),

              // 👈 اضافی اسپیس تاکہ سبمٹ بٹن انگوٹھے سے آرام سے اوپر لایا جا سکے
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}