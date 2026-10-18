import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'package:nayab_qist_point_customer/customer_side/login/services/login_payload_service.dart';

class LoginStorageHandler {
  static Future<Map<String, String>?> getRememberedCredentials() async {
    try {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
      final bool isRemembered = box.get('is_remember_me') == true;
      if (isRemembered) {
        final phone = box.get('remembered_phone')?.toString() ?? '';
        final pin = box.get('remembered_pin')?.toString() ?? '';
        if (phone.isNotEmpty) {
          return {'phone': phone, 'pin': pin};
        }
      }
    } catch (_) {}
    return null;
  }

  static Future<Map<String, String>?> getBiometricCredentials() async {
    try {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
      final String? phone = box.get('remembered_phone') ?? box.get('last_logged_phone');
      final String? pin = box.get('remembered_pin');
      if (phone != null && pin != null && phone.isNotEmpty && pin.isNotEmpty) {
        return {'phone': phone, 'pin': pin};
      }
    } catch (_) {}
    return null;
  }

  static Future<Map<String, dynamic>> verifyUserCredentials({
    required String phone,
    required String enteredPin,
    required bool rememberMe,
  }) async {
    try {
      final usersBox = await HiveBoxManager.openSafeBox(HiveBoxManager.usersBoxName);
      final rawUser = usersBox.get(phone);

      if (rawUser == null) {
        return {
          'success': false,
          'message': 'یہ موبائل نمبر رجسٹرڈ نہیں ہے',
        };
      }

      if (rawUser is Map) {
        final String savedPin = (rawUser['pin'] ?? rawUser['password'])?.toString() ?? '';
        if (savedPin.isEmpty || savedPin != enteredPin) {
          return {
            'success': false,
            'message': 'درج کردہ پاسورڈ (PIN) غلط ہے',
          };
        }

        final sessionPayload = LoginPayloadService.buildLoginSessionPayload(
          phone: phone,
          rememberMe: rememberMe,
          pin: enteredPin,
        );

        final settingsBox = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
        for (final entry in sessionPayload.entries) {
          await settingsBox.put(entry.key, entry.value);
        }

        return {
          'success': true,
          'message': 'کامیاب لاگ ان',
          'userData': rawUser,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'لاگ ان کے دوران خرابی پیش آئی: $e',
      };
    }

    return {
      'success': false,
      'message': 'صارف کا ڈیٹا درست فارمیٹ میں نہیں ہے',
    };
  }

  static Future<void> saveCloudUserLocally({
    required String phone,
    required Map<String, dynamic> userData,
  }) async {
    final usersBox = await HiveBoxManager.openSafeBox(HiveBoxManager.usersBoxName);
    await usersBox.put(phone, userData);
  }
}