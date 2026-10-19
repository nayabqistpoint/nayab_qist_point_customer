import 'package:flutter/material.dart';
import 'universal_payment_args.dart';
import 'universal_payment_controller.dart';
import 'components/payment_app_bar_ui.dart';
import 'components/payment_target_card_ui.dart';
import 'components/payment_sources_split_card_ui.dart';
import 'components/payment_adjustment_card_ui.dart';
import 'components/payment_notes_media_card_ui.dart';
import 'components/payment_footer_action_bar_ui.dart';

class UniversalPaymentPage extends StatefulWidget {
  final UniversalPaymentArgs? args;

  final String? title;
  final int? baseAmount;
  final bool? isInstallment;
  final String? itemName;
  final String? planTitle;
  final int? installmentNo;
  final int? maxAllowedAmount;

  const UniversalPaymentPage({
    super.key,
    this.args,
    this.title,
    this.baseAmount,
    this.isInstallment,
    this.itemName,
    this.planTitle,
    this.installmentNo,
    this.maxAllowedAmount,
  });

  @override
  State<UniversalPaymentPage> createState() => _UniversalPaymentPageState();
}

class _UniversalPaymentPageState extends State<UniversalPaymentPage> {
  late final UniversalPaymentController controller;

  @override
  void initState() {
    super.initState();
    final effectiveArgs = widget.args ??
        UniversalPaymentArgs(
          title: widget.title ?? 'ادائیگی رسید',
          baseAmount: widget.baseAmount ?? 0,
          isInstallment: widget.isInstallment ?? true,
          itemName: widget.itemName,
          planTitle: widget.planTitle,
          installmentNo: widget.installmentNo,
          maxAllowedAmount: widget.maxAllowedAmount,
        );

    controller = UniversalPaymentController(args: effectiveArgs);
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
            appBar: PaymentAppBarUi(title: controller.title),
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaymentTargetCardUi(controller: controller),
                  const SizedBox(height: 14),
                  PaymentSourcesSplitCardUi(
                    controller: controller,
                    onStateChange: () => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  PaymentAdjustmentCardUi(controller: controller),
                  const SizedBox(height: 14),
                  PaymentNotesMediaCardUi(controller: controller),
                  const SizedBox(height: 16),
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