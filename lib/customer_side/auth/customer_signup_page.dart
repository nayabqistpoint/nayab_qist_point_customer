import 'package:flutter/material.dart';
import '../inspector/floating_inspector_ui.dart';
import 'customer_signup_controller.dart';
import 'components/signup_app_bar_ui.dart';
import 'components/signup_step_tracker_ui.dart';
import 'components/step1_customer_info_ui.dart';
import 'components/step2_customer_media_ui.dart';
import 'components/step3_guarantor_and_terms_ui.dart';
import 'components/signup_bottom_action_bar_ui.dart';

class CustomerSignupPage extends StatefulWidget {
  const CustomerSignupPage({super.key});

  @override
  State<CustomerSignupPage> createState() => _CustomerSignupPageState();
}

class _CustomerSignupPageState extends State<CustomerSignupPage> {
  late final CustomerSignupController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CustomerSignupController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleNextOrSubmit() {
    if (_controller.currentStep < 2) {
      _controller.nextStep();
    } else {
      // 🎯 کنٹرولر کا مرکزی ہینڈلر کال ہوگا جو ویلیڈیشن، رسید شیٹ، ہائیو سروس اور انسپکٹر لاگ سب ایک فلو میں چلائے گا
      _controller.handleFinalSubmit(
        context,
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFF059669),
              content: Text('مبارک ہو! رجسٹریشن کامیابی سے مکمل ہو گئی ہے'),
            ),
          );
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: const SignupAppBarUi(),
            body: Column(
              children: [
                SignupStepTrackerUi(
                  currentStep: _controller.currentStep,
                  onStepTapped: _controller.setStep,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: _buildActiveStep(),
                  ),
                ),
                SignupBottomActionBarUi(
                  currentStep: _controller.currentStep,
                  onBack: _controller.previousStep,
                  onNextOrSubmit: _handleNextOrSubmit,
                ),
              ],
            ),
            // 🐛 لائیو پے لوڈ انسپکٹر فلوٹنگ بٹن
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFF0F172A),
              mini: true,
              child: const Icon(Icons.bug_report, color: Color(0xFF10B981), size: 20),
              onPressed: () => FloatingInspectorUi.show(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveStep() {
    switch (_controller.currentStep) {
      case 0:
        return Step1CustomerInfoUi(controller: _controller);
      case 1:
        return Step2CustomerMediaUi(controller: _controller);
      case 2:
        return Step3GuarantorAndTermsUi(controller: _controller);
      default:
        return const SizedBox.shrink();
    }
  }
}