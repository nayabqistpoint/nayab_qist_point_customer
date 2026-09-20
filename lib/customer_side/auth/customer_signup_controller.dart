import 'package:flutter/material.dart';
import '../payload_services/signup_payload_service.dart';
import '../hive_services/hive_box_manager.dart';
import '../inspector/submission_receipt_sheet_ui.dart';

class CustomerSignupController extends ChangeNotifier {
  int currentStep = 0;
  bool isSubmitting = false;
  bool agreementAccepted = false;

  // مرحله 1: بنیادی کنٹرولرز
  final nameCtrl = TextEditingController();
  final fatherCtrl = TextEditingController();
  final casteCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cnicCtrl = TextEditingController();
  final pinCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  // مرحله 2: میڈیا ٹوگلز
  bool isCnicFrontUploaded = false;
  bool isCnicBackUploaded = false;
  bool isSelfieUploaded = false;
  bool isAudioRecorded = false;

  // مرحله 3: ضامن کنٹرولرز
  final gNameCtrl = TextEditingController();
  final gFatherCtrl = TextEditingController();
  final gCasteCtrl = TextEditingController();
  final gPhoneCtrl = TextEditingController();
  final gCnicCtrl = TextEditingController();
  final gRelationCtrl = TextEditingController();
  final gAddressCtrl = TextEditingController();
  bool isGuarantorCnicFrontUploaded = false;
  bool isGuarantorCnicBackUploaded = false;

  // نیویگیشن
  void setStep(int step) { currentStep = step; notifyListeners(); }
  void nextStep() { if (currentStep < 2) { currentStep++; notifyListeners(); } }
  void previousStep() { if (currentStep > 0) { currentStep--; notifyListeners(); } }

  // میڈیا ٹوگل میتھڈز (UI مطابقت کے لیے)
  void toggleCnicFront() { isCnicFrontUploaded = !isCnicFrontUploaded; notifyListeners(); }
  void toggleCnicBack() { isCnicBackUploaded = !isCnicBackUploaded; notifyListeners(); }
  void toggleSelfie() { isSelfieUploaded = !isSelfieUploaded; notifyListeners(); }
  void toggleAudio() { isAudioRecorded = !isAudioRecorded; notifyListeners(); }
  void toggleAgreement(bool? val) { agreementAccepted = val ?? false; notifyListeners(); }

  /// تمام فیلڈز کو ایک منظم میپ میں جمع کرنا
  Map<String, dynamic> _collectFormData() {
    return {
      'phone': phoneCtrl.text,
      'name': nameCtrl.text,
      'fatherName': fatherCtrl.text,
      'caste': casteCtrl.text,
      'cnic': cnicCtrl.text,
      'pin': pinCtrl.text,
      'address': addressCtrl.text,
      'agreementAccepted': agreementAccepted,
      'isCnicFrontUploaded': isCnicFrontUploaded,
      'isCnicBackUploaded': isCnicBackUploaded,
      'isSelfieUploaded': isSelfieUploaded,
      'isAudioRecorded': isAudioRecorded,
      'gName': gNameCtrl.text,
      'gFather': gFatherCtrl.text,
      'gCaste': gCasteCtrl.text,
      'gPhone': gPhoneCtrl.text,
      'gCnic': gCnicCtrl.text,
      'gRelation': gRelationCtrl.text,
      'gAddress': gAddressCtrl.text,
      'isGuarantorCnicFrontUploaded': isGuarantorCnicFrontUploaded,
      'isGuarantorCnicBackUploaded': isGuarantorCnicBackUploaded,
    };
  }

  // فائنل سبمٹ ہینڈلر
  Future<void> handleFinalSubmit(BuildContext context, {required VoidCallback onSuccess}) async {
    final formData = _collectFormData();
    final error = SignupPayloadService.validate(formData);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error, textDirection: TextDirection.rtl),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
      return;
    }

    final phone = (formData['phone'] as String).trim().replaceAll(RegExp(r'[^0-9]'), '');
    final allPayloads = SignupPayloadService.buildAllPayloads(formData);

    SubmissionReceiptSheetUi.show(
      context,
      title: 'کسٹمر رجسٹریشن تصدیق',
      subtitle: 'تمام معلومات کی جانچ کے بعد کنفرم کریں',
      rawPayload: allPayloads,
      onConfirm: () async {
        isSubmitting = true;
        notifyListeners();

        // سیشن باکسز اوپن کرنا اور بیچ رائٹ چلانا
        await HiveBoxManager.openSessionBoxes();
        final isSaved = await HiveBoxManager.writeBatchPayloads(
          docId: phone,
          payloads: allPayloads,
          logTitle: 'کسٹمر رجسٹریشن مکمل',
        );

        if (isSaved) {
          final settingsBox = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
          await settingsBox.put('isLoggedIn', true);
          await settingsBox.put('activePhone', phone);
        }

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