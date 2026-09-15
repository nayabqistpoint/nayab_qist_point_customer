import 'package:flutter/material.dart';

class CustomerSignupController extends ChangeNotifier {
  int currentStep = 0; // 0: کسٹمر کوائف، 1: دستاویزات، 2: ضامن و اقرار

  // مرحلہ 1: کسٹمر بنیادی معلومات
  final nameCtrl = TextEditingController();
  final fatherCtrl = TextEditingController();
  final casteCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cnicCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  // مرحلہ 2: دستاویزات اور میڈیا اسٹیٹس
  bool isCnicFrontUploaded = false;
  bool isCnicBackUploaded = false;
  bool isSelfieUploaded = false;
  bool isAudioRecorded = false;

  // مرحلہ 3: ضامن معلومات (اختیاری)
  final gNameCtrl = TextEditingController();
  final gFatherCtrl = TextEditingController();
  final gCasteCtrl = TextEditingController();
  final gPhoneCtrl = TextEditingController();
  final gCnicCtrl = TextEditingController();
  final gRelationCtrl = TextEditingController();
  final gAddressCtrl = TextEditingController();
  bool isGuarantorCnicFrontUploaded = false;
  bool isGuarantorCnicBackUploaded = false;

  // قانونی اقرار نامہ چیک باکس
  bool agreementAccepted = false;

  // نیویگیشن طریقے
  void setStep(int step) {
    if (step >= 0 && step <= 2) {
      currentStep = step;
      notifyListeners();
    }
  }

  void nextStep() {
    if (currentStep < 2) {
      currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  // میڈیا ٹوگلز (ڈمی ٹیسٹنگ کیلئے)
  void toggleCnicFront() {
    isCnicFrontUploaded = !isCnicFrontUploaded;
    notifyListeners();
  }

  void toggleCnicBack() {
    isCnicBackUploaded = !isCnicBackUploaded;
    notifyListeners();
  }

  void toggleSelfie() {
    isSelfieUploaded = !isSelfieUploaded;
    notifyListeners();
  }

  void toggleAudio() {
    isAudioRecorded = !isAudioRecorded;
    notifyListeners();
  }

  void toggleAgreement(bool? val) {
    agreementAccepted = val ?? false;
    notifyListeners();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    fatherCtrl.dispose();
    casteCtrl.dispose();
    phoneCtrl.dispose();
    cnicCtrl.dispose();
    addressCtrl.dispose();
    gNameCtrl.dispose();
    gFatherCtrl.dispose();
    gCasteCtrl.dispose();
    gPhoneCtrl.dispose();
    gCnicCtrl.dispose();
    gRelationCtrl.dispose();
    gAddressCtrl.dispose();
    super.dispose();
  }
}