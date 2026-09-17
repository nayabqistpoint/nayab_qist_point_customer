import 'package:flutter/material.dart';
import '../payload_services/signup_payload_service.dart';
import '../hive_services/customer_registration_service.dart';
import '../inspector/submission_receipt_sheet_ui.dart';

class CustomerSignupController extends ChangeNotifier {
  int currentStep = 0;
  bool isSubmitting = false;
  bool agreementAccepted = false;

  // مرحلہ 1: بنیادی کوائف کنٹرولرز
  final nameCtrl = TextEditingController();
  final fatherCtrl = TextEditingController();
  final casteCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cnicCtrl = TextEditingController();
  final pinCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  // مرحلہ 2: میڈیا اسٹیٹس
  bool isCnicFrontUploaded = false;
  bool isCnicBackUploaded = false;
  bool isSelfieUploaded = false;
  bool isAudioRecorded = false;

  // مرحلہ 3: ضامن کنٹرولرز
  final gNameCtrl = TextEditingController();
  final gFatherCtrl = TextEditingController();
  final gCasteCtrl = TextEditingController();
  final gPhoneCtrl = TextEditingController();
  final gCnicCtrl = TextEditingController();
  final gRelationCtrl = TextEditingController();
  final gAddressCtrl = TextEditingController();
  bool isGuarantorCnicFrontUploaded = false;
  bool isGuarantorCnicBackUploaded = false;

  // نیویگیشن طریقے
  void setStep(int step) { currentStep = step; notifyListeners(); }
  void nextStep() { if (currentStep < 2) { currentStep++; notifyListeners(); } }
  void previousStep() { if (currentStep > 0) { currentStep--; notifyListeners(); } }

  // مرحلہ 2 ٹوگلز
  void toggleCnicFront() { isCnicFrontUploaded = !isCnicFrontUploaded; notifyListeners(); }
  void toggleCnicBack() { isCnicBackUploaded = !isCnicBackUploaded; notifyListeners(); }
  void toggleSelfie() { isSelfieUploaded = !isSelfieUploaded; notifyListeners(); }
  void toggleAudio() { isAudioRecorded = !isAudioRecorded; notifyListeners(); }
  void toggleAgreement(bool? val) { agreementAccepted = val ?? false; notifyListeners(); }

  // فائنل سبمٹ ہینڈلر
  Future<void> handleFinalSubmit(BuildContext context, {required VoidCallback onSuccess}) async {
    final error = SignupPayloadService.validate(this);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error, textDirection: TextDirection.rtl),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
      return;
    }

    final phone = phoneCtrl.text.trim().replaceAll(RegExp(r'[^0-9]'), '');

    // 🎯 1. چاروں آزاد پے لوڈز کی پے لوڈ سروس سے تیاری
    final customerPayload = SignupPayloadService.buildCustomerBoxPayload(controller: this);
    final guarantorPayload = SignupPayloadService.buildGuarantorBoxPayload(controller: this);
    final mediaPayload = SignupPayloadService.buildMediaBoxPayload(controller: this);
    final usersPayload = SignupPayloadService.buildUsersBoxPayload(controller: this);

    SubmissionReceiptSheetUi.show(
      context,
      title: 'کسٹمر رجسٹریشن تصدیق',
      subtitle: 'تمام معلومات کی جانچ کے بعد کنفرم کریں',
      rawPayload: {
        'customerBox': customerPayload,
        'guarantorBox': guarantorPayload,
        'mediaBox': mediaPayload,
        'usersBox': usersPayload,
      },
      onConfirm: () async {
        isSubmitting = true;
        notifyListeners();

        // 🎯 2. رجسٹریشن سروس کو چاروں خانے سپرد کرنا
        final isSaved = await CustomerRegistrationService.executeRegistration(
          phone: phone,
          customerPayload: customerPayload,
          guarantorPayload: guarantorPayload,
          mediaPayload: mediaPayload,
          usersPayload: usersPayload,
        );

        isSubmitting = false;
        notifyListeners();

        if (isSaved) {
          onSuccess();
        } else if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('رجسٹریشن محفوظ کرنے میں خرابی ہوئی!')),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    final controllers = [
      nameCtrl, fatherCtrl, casteCtrl, phoneCtrl, cnicCtrl, pinCtrl, addressCtrl,
      gNameCtrl, gFatherCtrl, gCasteCtrl, gPhoneCtrl, gCnicCtrl, gRelationCtrl, gAddressCtrl,
    ];
    for (final c in controllers) {
      c.dispose();
    }
    super.dispose();
  }
}