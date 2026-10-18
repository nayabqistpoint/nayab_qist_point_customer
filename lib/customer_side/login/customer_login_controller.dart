import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';
import 'package:nayab_qist_point_customer/customer_side/login/services/login_storage_handler.dart';
import 'package:nayab_qist_point_customer/customer_side/login/services/login_cloud_sync_service.dart';
import 'package:nayab_qist_point_customer/customer_side/login/services/login_biometric_service.dart';
import 'package:nayab_qist_point_customer/customer_side/login/services/login_contact_service.dart';
import 'package:nayab_qist_point_customer/customer_side/login/services/login_whatsapp_service.dart';

class CustomerLoginController extends ChangeNotifier {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool rememberMe = false;

  final syncService = LoginCloudSyncService();
  final biometricService = LoginBiometricService();
  final contactService = LoginContactService();
  final whatsappService = LoginWhatsappService();

  Future<void> initSavedCredentials([String? initialPhone]) async {
    if (initialPhone != null && initialPhone.isNotEmpty) {
      phoneController.text = initialPhone;
    }
    final creds = await LoginStorageHandler.getRememberedCredentials();
    if (creds != null) {
      phoneController.text = creds['phone'] ?? phoneController.text;
      passwordController.text = creds['pin'] ?? '';
      rememberMe = true;
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void setRememberMe(bool? val) {
    rememberMe = val ?? false;
    notifyListeners();
  }

  Future<void> submitLogin(BuildContext context) async {
    final phone = phoneController.text.trim();
    final pin = passwordController.text.trim();
    if (phone.isEmpty || pin.isEmpty) {
      _showMsg(context, 'موبائل نمبر اور پن کوڈ درج کریں', true);
      return;
    }

    var res = await LoginStorageHandler.verifyUserCredentials(
      phone: phone,
      enteredPin: pin,
      rememberMe: rememberMe,
    );

    if (res['success'] == false && res['message'] == 'یہ موبائل نمبر رجسٹرڈ نہیں ہے') {
      if (await syncService.syncUserFromCloud(phone)) {
        res = await LoginStorageHandler.verifyUserCredentials(
          phone: phone,
          enteredPin: pin,
          rememberMe: rememberMe,
        );
      }
    }

    if (!context.mounted) return;
    if (res['success'] == true) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.ledger,
        arguments: {'customerPhone': phone},
      );
    } else {
      _showMsg(context, res['message'] ?? 'لاگ ان ناکام', true);
    }
  }

  Future<void> triggerBiometric(BuildContext context) async {
    final isAvailable = await biometricService.isBiometricAvailable();
    if (!isAvailable) {
      if (context.mounted) {
        _showMsg(context, 'اس ڈیوائس پر فنگر پرنٹ سنسر دستیاب نہیں ہے!', true);
      }
      return;
    }

    final creds = await LoginStorageHandler.getBiometricCredentials();
    if (creds == null) {
      if (context.mounted) {
        _showMsg(context, 'پہلے ایک بار پاسورڈ سے لاگ ان کریں!', true);
      }
      return;
    }

    final authenticated = await biometricService.authenticate();
    if (authenticated && context.mounted) {
      phoneController.text = creds['phone'] ?? '';
      passwordController.text = creds['pin'] ?? '';
      await submitLogin(context);
    }
  }

  void _showMsg(BuildContext context, String msg, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red[800] : const Color(0xFF059669),
        content: Text(msg, textDirection: TextDirection.rtl),
      ),
    );
  }

  void makeCall() => contactService.makePhoneCall();
  void openWhatsApp() => whatsappService.openWhatsApp();
  void navigateToSignUp(BuildContext context) => Navigator.pushNamed(context, AppRoutes.customerSignup);
  void navigateToCalculator(BuildContext context) => Navigator.pushNamed(context, AppRoutes.purchaseMarket);

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}