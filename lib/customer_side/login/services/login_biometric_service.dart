import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'login_auth_service.dart';

class LoginBiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<void> authenticateAndLogin({
    required BuildContext context,
    required LoginAuthService authService,
  }) async {
    if (kIsWeb) {
      authService.showToast(context, 'فنگر پرنٹ تصدیق صرف اینڈرائیڈ / موبائل پر دستیاب ہے!', isError: true);
      return;
    }

    try {
      if (!await _auth.canCheckBiometrics && !await _auth.isDeviceSupported()) {
        if (context.mounted) {
          authService.showToast(context, 'اس ڈیوائس پر فنگر پرنٹ سنسر دستیاب نہیں ہے!', isError: true);
        }
        return;
      }

      final box = Hive.isBoxOpen('settingsBox') ? Hive.box('settingsBox') : await Hive.openBox('settingsBox');
      final String? phone = box.get('remembered_phone') ?? box.get('last_logged_phone');
      final String? pin = box.get('remembered_pin');

      if (phone == null || pin == null) {
        if (context.mounted) {
          authService.showToast(context, 'پہلے ایک بار پاسورڈ سے لاگ ان کریں!', isError: true);
        }
        return;
      }

      final bool didAuth = await _auth.authenticate(
        localizedReason: 'لاگ ان کرنے کے لیے فنگر پرنٹ سکین کریں',
      );

      if (didAuth && context.mounted) {
        await authService.performLogin(
          context: context,
          phone: phone,
          password: pin,
          rememberMe: true,
        );
      }
    } catch (e) {
      if (context.mounted) {
        authService.showToast(context, 'فنگر پرنٹ تصدیق ناکام: $e', isError: true);
      }
    }
  }
}