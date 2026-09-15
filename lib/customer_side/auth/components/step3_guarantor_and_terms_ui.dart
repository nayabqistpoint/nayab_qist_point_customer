import 'package:flutter/material.dart';
import '../customer_signup_controller.dart';
import 'guarantor_info_card_ui.dart';
import 'legal_agreement_card_ui.dart';

class Step3GuarantorAndTermsUi extends StatelessWidget {
  final CustomerSignupController controller;

  const Step3GuarantorAndTermsUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GuarantorInfoCardUi(controller: controller),
        const SizedBox(height: 18),
        LegalAgreementCardUi(
          agreementAccepted: controller.agreementAccepted,
          onAgreementChanged: controller.toggleAgreement,
        ),
      ],
    );
  }
}