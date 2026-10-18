import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'package:nayab_qist_point_customer/customer_side/auth/services/signup_payload_service.dart';

class SignupStorageHandler {
  static String? validateFormData(Map<String, dynamic> rawData) {
    return SignupPayloadService.validate(rawData);
  }

  static Map<String, Map<String, dynamic>> prepareSignupPayloads(Map<String, dynamic> rawData) {
    return SignupPayloadService.buildAllPayloads(rawData);
  }

  static Future<bool> executeSignupBatch({
    required String phone,
    required Map<String, Map<String, dynamic>> allPayloads,
  }) async {
    await HiveBoxManager.openSessionBoxes();

    final bool isSaved = await HiveBoxManager.writeBatchPayloads(
      docId: phone,
      payloads: allPayloads,
      logTitle: 'کسٹمر رجسٹریشن مکمل',
    );

    if (isSaved) {
      final settingsBox = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
      await settingsBox.put('isLoggedIn', true);
      await settingsBox.put('activePhone', phone);
      return true;
    }
    return false;
  }
}