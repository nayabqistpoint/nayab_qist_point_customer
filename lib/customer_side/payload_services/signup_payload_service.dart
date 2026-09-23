import '../hive_services/hive_box_manager.dart';
import 'signup_payload_builders/customer_payload_builder.dart';
import 'signup_payload_builders/guarantor_payload_builder.dart';
import 'signup_payload_builders/media_payload_builder.dart';
import 'signup_payload_builders/user_auth_payload_builder.dart';

class SignupPayloadService {
  /// فارم کی بنیادی تصدیق
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

  /// چاروں بلڈرز کو یکجا کر کے حتمی پے لوڈ بنانا
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

  /// انسپکٹر بینچ مارک
  static Map<String, dynamic> getBenchmarkPayload() => buildAllPayloads();
}