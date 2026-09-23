import 'package:flutter/material.dart';
import '../../../core/services/audio_service.dart';
import 'services/signup_media_service.dart';
import 'services/signup_submit_service.dart';

class CustomerSignupController extends ChangeNotifier {
  final media = SignupMediaService();

  int currentStep = 0;
  bool isSubmitting = false;
  bool agreementAccepted = false;

  // مرحله ۱: کسٹمر فیلڈز
  final nameCtrl = TextEditingController();
  final fatherCtrl = TextEditingController();
  final casteCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cnicCtrl = TextEditingController();
  final pinCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  // مرحله ۳: ضامن فیلڈز
  final gNameCtrl = TextEditingController();
  final gFatherCtrl = TextEditingController();
  final gCasteCtrl = TextEditingController();
  final gPhoneCtrl = TextEditingController();
  final gCnicCtrl = TextEditingController();
  final gRelationCtrl = TextEditingController();
  final gAddressCtrl = TextEditingController();

  // UI کے لیے گیٹرز
  bool get isCnicFrontUploaded => media.cnicFront.isNotEmpty;
  bool get isCnicBackUploaded => media.cnicBack.isNotEmpty;
  bool get isSelfieUploaded => media.selfie.isNotEmpty;
  bool get isAudioRecorded => GlobalAudioService.audioPath.isNotEmpty;
  bool get isRecording => GlobalAudioService.isRecording;
  bool get isPlayingAudio => GlobalAudioService.isPlaying;
  Duration get audioDuration => GlobalAudioService.duration;
  Duration get audioPosition => GlobalAudioService.position;
  String formatDuration(Duration d) => GlobalAudioService.formatDuration(d);

  bool get isGuarantorCnicFrontUploaded => media.gCnicFront.isNotEmpty;
  set isGuarantorCnicFrontUploaded(bool val) {
    if (!val) {
      media.gCnicFront = '';
      notifyListeners();
    }
  }

  bool get isGuarantorCnicBackUploaded => media.gCnicBack.isNotEmpty;
  set isGuarantorCnicBackUploaded(bool val) {
    if (!val) {
      media.gCnicBack = '';
      notifyListeners();
    }
  }

  // نیویگیشن
  void setStep(int s) { currentStep = s; notifyListeners(); }
  void nextStep() { if (currentStep < 2) { currentStep++; notifyListeners(); } }
  void previousStep() { if (currentStep > 0) { currentStep--; notifyListeners(); } }
  void toggleAgreement(bool? val) { agreementAccepted = val ?? false; notifyListeners(); }

  // میڈیا ایکشنز
  void toggleCnicFront() => media.pickDoc('cnicFront', onUpdate: notifyListeners);
  void toggleCnicBack() => media.pickDoc('cnicBack', onUpdate: notifyListeners);
  void toggleGuarantorCnicFront() => media.pickDoc('gCnicFront', onUpdate: notifyListeners);
  void toggleGuarantorCnicBack() => media.pickDoc('gCnicBack', onUpdate: notifyListeners);
  void toggleSelfie() => media.pickSelfie(onUpdate: notifyListeners);

  // آڈیو ایکشنز
  void toggleAudio() => GlobalAudioService.toggleRecord(onUpdate: notifyListeners);
  void togglePlayAudio() => GlobalAudioService.togglePlay(onUpdate: notifyListeners);
  void deleteAudio() => GlobalAudioService.deleteAudio(onUpdate: notifyListeners);

  // فائنل سبمٹ (🎯 تمام کیز کو نئے اور مستقل معیار کے مطابق سیٹ کر دیا گیا ہے)
  Future<void> handleFinalSubmit(BuildContext context, {required VoidCallback onSuccess}) async {
    final data = {
      // کسٹمر معلومات
      'customerPhone': phoneCtrl.text.trim(),
      'customerName': nameCtrl.text.trim(),
      'customerFatherName': fatherCtrl.text.trim(),
      'customerCaste': casteCtrl.text.trim(),
      'customerCnic': cnicCtrl.text.trim(),
      'customerAddress': addressCtrl.text.trim(),
      'pin': pinCtrl.text.trim(),
      'agreementAccepted': agreementAccepted,

      // کسٹمر میڈیا
      'customerCnicFront': media.cnicFront,
      'customerCnicBack': media.cnicBack,
      'customerSelfie': media.selfie,
      'customerAudio': GlobalAudioService.audioPath,

      // ضامن معلومات
      'guarantorName': gNameCtrl.text.trim(),
      'guarantorFatherName': gFatherCtrl.text.trim(),
      'guarantorCaste': gCasteCtrl.text.trim(),
      'guarantorPhone': gPhoneCtrl.text.trim(),
      'guarantorCnic': gCnicCtrl.text.trim(),
      'guarantorRelation': gRelationCtrl.text.trim(),
      'guarantorAddress': gAddressCtrl.text.trim(),

      // ضامن میڈیا
      'guarantorCnicFront': media.gCnicFront,
      'guarantorCnicBack': media.gCnicBack,
    };

    await SignupSubmitService.process(
      context: context,
      data: data,
      onStart: () { isSubmitting = true; notifyListeners(); },
      onEnd: () { isSubmitting = false; notifyListeners(); },
      onSuccess: onSuccess,
    );
  }

  @override
  void dispose() {
    GlobalAudioService.dispose();
    final list = [
      nameCtrl, fatherCtrl, casteCtrl, phoneCtrl, cnicCtrl, pinCtrl, addressCtrl,
      gNameCtrl, gFatherCtrl, gCasteCtrl, gPhoneCtrl, gCnicCtrl, gRelationCtrl, gAddressCtrl,
    ];
    for (final c in list) {
      c.dispose();
    }
    super.dispose();
  }
}