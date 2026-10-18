import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'package:nayab_qist_point_customer/customer_side/auth/services/payload_builders/customer_payload_builder.dart';
import 'package:nayab_qist_point_customer/customer_side/auth/services/payload_builders/guarantor_payload_builder.dart';
import 'package:nayab_qist_point_customer/customer_side/auth/services/payload_builders/media_payload_builder.dart';
import 'package:nayab_qist_point_customer/customer_side/auth/services/payload_builders/user_auth_payload_builder.dart';

class SignupPayloadService {
  static String? validate(Map<String, dynamic> data) {
    final phone = (data['phone'] ?? data['customerPhone'] ?? '').toString().trim().replaceAll(RegExp(r'[^0-9]'), '');
    final cnic = (data['cnic'] ?? data['customerCnic'] ?? '').toString().trim().replaceAll(RegExp(r'[^0-9]'), '');
    final pin = (data['pin'] ?? '').toString().trim();
    final name = (data['name'] ?? data['customerName'] ?? '').toString().trim();

    if (phone.length != 11) return 'درست 11 ہندسوں کا موبائل نمبر درج کریں';
    if (name.isEmpty) return 'کسٹمر کا پورا نام درج کریں';
    if (cnic.length != 13) return 'شناختی کارڈ 13 ہندسوں کا ہونا ضروری ہے';
    if (pin.length < 4) return 'کم از کم 4 ہندسوں کا پن کوڈ درج کریں';
    if (data['agreementAccepted'] != true) return 'اقرار نامہ قبول کریں';
    return null;
  }

  static Map<String, dynamic> bundleFormData({
    required String phone,
    required String name,
    required String fatherName,
    required String caste,
    required String cnic,
    required String address,
    required String pin,
    required bool agreementAccepted,
    required String cnicFront,
    required String cnicBack,
    required String selfie,
    required String audioPath,
    required String gName,
    required String gFather,
    required String gCaste,
    required String gPhone,
    required String gCnic,
    required String gRelation,
    required String gAddress,
    required String gCnicFront,
    required String gCnicBack,
  }) {
    return {
      'customerPhone': phone.trim(),
      'customerName': name.trim(),
      'customerFatherName': fatherName.trim(),
      'customerCaste': caste.trim(),
      'customerCnic': cnic.trim(),
      'customerAddress': address.trim(),
      'pin': pin.trim(),
      'agreementAccepted': agreementAccepted,
      'customerCnicFront': cnicFront,
      'customerCnicBack': cnicBack,
      'customerSelfie': selfie,
      'customerAudio': audioPath,
      'guarantorName': gName.trim(),
      'guarantorFatherName': gFather.trim(),
      'guarantorCaste': gCaste.trim(),
      'guarantorPhone': gPhone.trim(),
      'guarantorCnic': gCnic.trim(),
      'guarantorRelation': gRelation.trim(),
      'guarantorAddress': gAddress.trim(),
      'guarantorCnicFront': gCnicFront,
      'guarantorCnicBack': gCnicBack,
    };
  }

  static Map<String, Map<String, dynamic>> buildAllPayloads([Map<String, dynamic>? d]) {
    final phone = (d?['phone'] ?? d?['customerPhone'] ?? '03012700351')
        .toString()
        .trim()
        .replaceAll(RegExp(r'[^0-9]'), '');

    return {
      HiveBoxManager.customerBoxName: CustomerPayloadBuilder.build(d, phone),
      HiveBoxManager.guarantorBoxName: GuarantorPayloadBuilder.build(d, phone),
      HiveBoxManager.mediaBoxName: MediaPayloadBuilder.build(d, phone),
      HiveBoxManager.usersBoxName: UserAuthPayloadBuilder.build(d, phone),
    };
  }

  static Map<String, dynamic> getBenchmarkPayload() => buildAllPayloads();
}