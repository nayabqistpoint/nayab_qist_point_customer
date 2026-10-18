import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/core/services/audio_service.dart';
import 'package:nayab_qist_point_customer/customer_side/auth/services/signup_media_service.dart';
import 'package:nayab_qist_point_customer/customer_side/auth/services/signup_storage_handler.dart';
import 'package:nayab_qist_point_customer/customer_side/inspector/submission_receipt_sheet_ui.dart';

class CustomerSignupController extends ChangeNotifier {
  final media = SignupMediaService();
  int currentStep = 0;
  bool isSubmitting = false;
  bool agreementAccepted = false;

  final nameCtrl = TextEditingController();
  final fatherCtrl = TextEditingController();
  final casteCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cnicCtrl = TextEditingController();
  final pinCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  final gNameCtrl = TextEditingController();
  final gFatherCtrl = TextEditingController();
  final gCasteCtrl = TextEditingController();
  final gPhoneCtrl = TextEditingController();
  final gCnicCtrl = TextEditingController();
  final gRelationCtrl = TextEditingController();
  final gAddressCtrl = TextEditingController();

  void initPhone(String? phone) {
    if (phone != null && phone.isNotEmpty) {
      phoneCtrl.text = phone;
    }
  }

  bool get isAudioRecorded => GlobalAudioService.audioPath.isNotEmpty;
  bool get isRecording => GlobalAudioService.isRecording;
  bool get isPlayingAudio => GlobalAudioService.isPlaying;
  Duration get audioDuration => GlobalAudioService.duration;
  Duration get audioPosition => GlobalAudioService.position;
  String formatDuration(Duration d) => GlobalAudioService.formatDuration(d);

  void setStep(int s) { currentStep = s; notifyListeners(); }
  void nextStep() { if (currentStep < 2) { currentStep++; notifyListeners(); } }
  void previousStep() { if (currentStep > 0) { currentStep--; notifyListeners(); } }
  void toggleAgreement(bool? val) { agreementAccepted = val ?? false; notifyListeners(); }

  void toggleCnicFront() => media.pickDoc('cnicFront', onUpdate: notifyListeners);
  void toggleCnicBack() => media.pickDoc('cnicBack', onUpdate: notifyListeners);
  void toggleGuarantorCnicFront() => media.pickDoc('gCnicFront', onUpdate: notifyListeners);
  void toggleGuarantorCnicBack() => media.pickDoc('gCnicBack', onUpdate: notifyListeners);
  void toggleSelfie() => media.pickSelfie(onUpdate: notifyListeners);
  void toggleAudio() => GlobalAudioService.toggleRecord(onUpdate: notifyListeners);
  void togglePlayAudio() => GlobalAudioService.togglePlay(onUpdate: notifyListeners);
  void deleteAudio() => GlobalAudioService.deleteAudio(onUpdate: notifyListeners);

  Map<String, dynamic> _collectRawFormData() {
    return {
      'customerPhone': phoneCtrl.text.trim(),
      'customerName': nameCtrl.text.trim(),
      'customerFatherName': fatherCtrl.text.trim(),
      'customerCaste': casteCtrl.text.trim(),
      'customerCnic': cnicCtrl.text.trim(),
      'customerAddress': addressCtrl.text.trim(),
      'pin': pinCtrl.text.trim(),
      'agreementAccepted': agreementAccepted,
      'customerCnicFront': media.cnicFront,
      'customerCnicBack': media.cnicBack,
      'customerSelfie': media.selfie,
      'customerAudio': GlobalAudioService.audioPath,
      'guarantorName': gNameCtrl.text.trim(),
      'guarantorFatherName': gFatherCtrl.text.trim(),
      'guarantorCaste': gCasteCtrl.text.trim(),
      'guarantorPhone': gPhoneCtrl.text.trim(),
      'guarantorCnic': gCnicCtrl.text.trim(),
      'guarantorRelation': gRelationCtrl.text.trim(),
      'guarantorAddress': gAddressCtrl.text.trim(),
      'guarantorCnicFront': media.gCnicFront,
      'guarantorCnicBack': media.gCnicBack,
    };
  }

  Future<void> handleFinalSubmit(BuildContext context, {required VoidCallback onSuccess}) async {
    final rawData = _collectRawFormData();

    final error = SignupStorageHandler.validateFormData(rawData);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error, textDirection: TextDirection.rtl), backgroundColor: const Color(0xFFDC2626)),
      );
      return;
    }

    final phone = (rawData['customerPhone'] ?? '').toString().replaceAll(RegExp(r'[^0-9]'), '');
    final allPayloads = SignupStorageHandler.prepareSignupPayloads(rawData);

    SubmissionReceiptSheetUi.show(
      context,
      title: 'کسٹمر رجسٹریشن تصدیق',
      subtitle: 'تمام معلومات کی جانچ کے بعد کنفرم کریں',
      rawPayload: allPayloads,
      onConfirm: () async {
        isSubmitting = true;
        notifyListeners();

        final success = await SignupStorageHandler.executeSignupBatch(
          phone: phone,
          allPayloads: allPayloads,
        );

        isSubmitting = false;
        notifyListeners();

        if (success) {
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
    GlobalAudioService.dispose();
    for (final c in [
      nameCtrl, fatherCtrl, casteCtrl, phoneCtrl, cnicCtrl, pinCtrl, addressCtrl,
      gNameCtrl, gFatherCtrl, gCasteCtrl, gPhoneCtrl, gCnicCtrl, gRelationCtrl, gAddressCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }
}