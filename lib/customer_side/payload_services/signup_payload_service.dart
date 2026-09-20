import '../hive_services/hive_box_manager.dart';

class SignupPayloadService {
  /// فارم کی تصدیق
  static String? validate(Map<String, dynamic> data) {
    final phone = (data['phone'] ?? '').toString().trim().replaceAll(RegExp(r'[^0-9]'), '');
    final cnic = (data['cnic'] ?? '').toString().trim().replaceAll(RegExp(r'[^0-9]'), '');
    final pin = (data['pin'] ?? '').toString().trim();
    final name = (data['name'] ?? '').toString().trim();

    if (phone.length != 11) return 'درست 11 ہندسوں کا موبائل نمبر درج کریں';
    if (name.isEmpty) return 'کسٹمر کا پورا نام درج کریں';
    if (cnic.length != 13) return 'شناختی کارڈ 13 ہندسوں کا ہونا ضروری ہے';
    if (pin.length < 4) return 'کم از کم 4 ہندسوں کا پن کوڈ درج کریں';
    if (data['agreementAccepted'] != true) return 'اقرار نامہ قبول کریں';
    return null;
  }

  /// 🎯 تمام باکسز کا پے لوڈ ایک ہی جگہ تیار کرنا
  static Map<String, Map<String, dynamic>> buildAllPayloads([Map<String, dynamic>? d]) {
    final phone = (d?['phone'] ?? '03012700351').toString().trim().replaceAll(RegExp(r'[^0-9]'), '');

    return {
      // 1. customerBox
      HiveBoxManager.customerBoxName: {
        'docId': phone,
        'customerPhone': phone,
        'phone': phone,
        'userName': phone,
        'fullName': d?['name'] ?? 'محمد محیب',
        'fatherName': d?['fatherName'] ?? 'احمد علی',
        'caste': d?['caste'] ?? 'آرائیں',
        'cnic': d?['cnic'] ?? '31202-1234567-1',
        'address': d?['address'] ?? 'مین بازار، قائم پور',
        'isAgreementAccepted': d?['agreementAccepted'] ?? true,
        'status': 'pending',
        'currentBalance': 0,
        'isSynced': false,
        'createdAt': DateTime.now().toIso8601String(),
      },

      // 2. guarantorBox
      HiveBoxManager.guarantorBoxName: {
        'customerPhone': phone,
        'guarantorName': d?['gName'] ?? 'عمران خان',
        'guarantorFatherName': d?['gFather'] ?? 'نور محمد',
        'guarantorCaste': d?['gCaste'] ?? 'راجپوت',
        'guarantorPhone': d?['gPhone'] ?? '03017654321',
        'guarantorCnic': d?['gCnic'] ?? '31202-7654321-2',
        'guarantorRelation': d?['gRelation'] ?? 'بھائی',
        'guarantorAddress': d?['gAddress'] ?? 'محلہ عیدگاہ، قائم پور',
        'isSynced': false,
        'updatedAt': DateTime.now().toIso8601String(),
      },

      // 3. mediaBox
      HiveBoxManager.mediaBoxName: {
        'customerPhone': phone,
        'isCnicFrontUploaded': d?['isCnicFrontUploaded'] ?? true,
        'isCnicBackUploaded': d?['isCnicBackUploaded'] ?? true,
        'isSelfieUploaded': d?['isSelfieUploaded'] ?? false,
        'isAudioRecorded': d?['isAudioRecorded'] ?? true,
        'isGuarantorCnicFrontUploaded': d?['isGuarantorCnicFrontUploaded'] ?? true,
        'isGuarantorCnicBackUploaded': d?['isGuarantorCnicBackUploaded'] ?? true,
        'isSynced': false,
        'updatedAt': DateTime.now().toIso8601String(),
      },

      // 4. usersBox (🎯 صرف 5 حتمی فیلڈز)
      HiveBoxManager.usersBoxName: {
        'phone': phone,
        'pin': (d?['pin'] ?? '7860').toString().trim(),
        'status': 'pending',
        'isSynced': false,
        'createdAt': DateTime.now().toIso8601String(),
      },
    };
  }

  /// 🔬 انسپکٹر بینچ مارک
  static Map<String, dynamic> getBenchmarkPayload() => buildAllPayloads();
}