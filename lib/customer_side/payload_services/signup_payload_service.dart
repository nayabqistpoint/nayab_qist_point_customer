import '../auth/customer_signup_controller.dart';

class SignupPayloadService {
  /// فارم کی تصدیق
  static String? validate(CustomerSignupController c) {
    final phone = c.phoneCtrl.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
    final cnic = c.cnicCtrl.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
    final pin = c.pinCtrl.text.trim();

    if (phone.length != 11) return 'درست 11 ہندسوں کا موبائل نمبر درج کریں';
    if (c.nameCtrl.text.trim().isEmpty) return 'کسٹمر کا پورا نام درج کریں';
    if (cnic.length != 13) return 'شناختی کارڈ 13 ہندسوں کا ہونا ضروری ہے';
    if (pin.length < 4) return 'کم از کم 4 ہندسوں کا پن کوڈ درج کریں';
    if (!c.agreementAccepted) return 'اقرار نامہ قبول کریں';
    return null;
  }

  /// 1. خالص کسٹمر پروفائل باکس پے لوڈ
  static Map<String, dynamic> buildCustomerBoxPayload({CustomerSignupController? controller}) {
    final c = controller;
    final phone = c != null
        ? c.phoneCtrl.text.trim().replaceAll(RegExp(r'[^0-9]'), '')
        : '03012700351';

    return {
      'docId': phone,
      'phone': phone,
      'userName': phone,
      'fullName': c?.nameCtrl.text.trim() ?? 'محمد محیب',
      'fatherName': c?.fatherCtrl.text.trim() ?? 'احمد علی',
      'caste': c?.casteCtrl.text.trim() ?? 'آرائیں',
      'cnic': c?.cnicCtrl.text.trim() ?? '31202-1234567-1',
      'address': c?.addressCtrl.text.trim() ?? 'مین بازار، قائم پور',
      'isAgreementAccepted': c?.agreementAccepted ?? true,
      'status': 'APPROVED',
      'currentBalance': 0,
      'isSynced': false,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  /// 2. ضامن / گواہ پے لوڈ
  static Map<String, dynamic> buildGuarantorBoxPayload({CustomerSignupController? controller}) {
    final c = controller;
    return {
      'guarantorName': c?.gNameCtrl.text.trim() ?? 'عمران خان',
      'guarantorFatherName': c?.gFatherCtrl.text.trim() ?? 'نور محمد',
      'guarantorCaste': c?.gCasteCtrl.text.trim() ?? 'راجپوت',
      'guarantorPhone': c?.gPhoneCtrl.text.trim() ?? '03017654321',
      'guarantorCnic': c?.gCnicCtrl.text.trim() ?? '31202-7654321-2',
      'guarantorRelation': c?.gRelationCtrl.text.trim() ?? 'بھائی',
      'guarantorAddress': c?.gAddressCtrl.text.trim() ?? 'محلہ عیدگاہ، قائم پور',
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// 3. میڈیا دستاویزات پے لوڈ
  static Map<String, dynamic> buildMediaBoxPayload({CustomerSignupController? controller}) {
    final c = controller;
    return {
      'isCnicFrontUploaded': c?.isCnicFrontUploaded ?? true,
      'isCnicBackUploaded': c?.isCnicBackUploaded ?? true,
      'isSelfieUploaded': c?.isSelfieUploaded ?? false,
      'isAudioRecorded': c?.isAudioRecorded ?? true,
      'isGuarantorCnicFrontUploaded': c?.isGuarantorCnicFrontUploaded ?? true,
      'isGuarantorCnicBackUploaded': c?.isGuarantorCnicBackUploaded ?? true,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// 4. یوزرز کریڈینشلز پے لوڈ (usersBox)
  static Map<String, dynamic> buildUsersBoxPayload({CustomerSignupController? controller}) {
    final c = controller;
    final phone = c != null
        ? c.phoneCtrl.text.trim().replaceAll(RegExp(r'[^0-9]'), '')
        : '03012700351';

    return {
      'userName': phone,
      'pinCode': c != null ? c.pinCtrl.text.trim() : '7860',
      'status': 'APPROVED',
      'fullName': c?.nameCtrl.text.trim() ?? 'محمد محیب',
      'registeredAt': DateTime.now().toIso8601String(),
    };
  }

  /// سروس مرر (Benchmark Mirror) - اب بالکل صاف اور فکسڈ باکسز کے نام
  static Map<String, dynamic> getBenchmarkPayload() {
    return {
      '1. Customer Profile (customerBox)': buildCustomerBoxPayload(),
      '2. Guarantor Details (guarantorBox)': buildGuarantorBoxPayload(),
      '3. Media Verification (mediaBox)': buildMediaBoxPayload(),
      '4. Credentials & Auth (usersBox)': buildUsersBoxPayload(),
    };
  }
}