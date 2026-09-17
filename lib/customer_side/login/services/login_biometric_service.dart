import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../../hive_services/hive_box_manager.dart';
import '../customer_login_controller.dart';

class LoginBiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<void> authenticateAndLogin({
    required BuildContext context,
    required CustomerLoginController controller,
  }) async {
    if (kIsWeb) {
      _toast(context, 'فنگر پرنٹ تصدیق صرف اینڈرائیڈ / موبائل پر دستیاب ہے!', true);
      return;
    }

    try {
      if (!await _auth.canCheckBiometrics && !await _auth.isDeviceSupported()) {
        if (context.mounted) {
          _toast(context, 'اس ڈیوائس پر فنگر پرنٹ سنسر دستیاب نہیں ہے!', true);
        }
        return;
      }

      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
      final String? phone = box.get('remembered_phone') ?? box.get('last_logged_phone');
      final String? pin = box.get('remembered_pin');

      if (phone == null || pin == null || phone.isEmpty || pin.isEmpty) {
        if (context.mounted) {
          _toast(context, 'پہلے ایک بار پاسورڈ سے لاگ ان کریں!', true);
        }
        return;
      }

      final bool didAuth = await _auth.authenticate(
        localizedReason: 'لاگ ان کرنے کے لیے فنگر پرنٹ سکین کریں',
      );

      if (didAuth && context.mounted) {
        controller.phoneController.text = phone;
        controller.passwordController.text = pin;
        await controller.submitLogin(context);
      }
    } catch (e) {
      if (context.mounted) {
        _toast(context, 'فنگر پرنٹ تصدیق ناکام: $e', true);
      }
    }
  }

  void _toast(BuildContext context, String msg, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red[800] : Colors.green[800],
        content: Text(msg, textDirection: TextDirection.rtl),
      ),
    );
  }
}