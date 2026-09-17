import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';
import '../payload_services/login_payload_service.dart';
import '../hive_services/login_hive_service.dart';
import 'services/login_cloud_sync_service.dart';
import 'services/login_biometric_service.dart';
import 'services/login_contact_service.dart';
import 'services/login_whatsapp_service.dart';

class CustomerLoginController extends ChangeNotifier {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool rememberMe = false;

  final syncService = LoginCloudSyncService();
  final biometricService = LoginBiometricService();
  final contactService = LoginContactService();
  final whatsappService = LoginWhatsappService();

  Future<void> initSavedCredentials() async {
    final creds = await LoginHiveService.getRememberedCredentials();
    if (creds != null) {
      phoneController.text = creds['phone'] ?? '';
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

    final payload = LoginPayloadService.buildLoginSessionPayload(
      phone: phone,
      rememberMe: rememberMe,
      pin: pin,
    );

    var res = await LoginHiveService.verifyAndExecuteLogin(
      phone: phone,
      enteredPin: pin,
      sessionPayload: payload,
    );

    // اگر لوکل یوزر نہیں ملا تو کلاؤڈ سنک آزمانا
    if (res['success'] == false && res['message'] == 'یہ موبائل نمبر رجسٹرڈ نہیں ہے') {
      if (await syncService.syncUserFromCloud(phone)) {
        res = await LoginHiveService.verifyAndExecuteLogin(
          phone: phone,
          enteredPin: pin,
          sessionPayload: payload,
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

  void _showMsg(BuildContext context, String msg, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red[800] : Colors.green[800],
        content: Text(msg, textDirection: TextDirection.rtl),
      ),
    );
  }

  void triggerBiometric(BuildContext context) =>
      biometricService.authenticateAndLogin(context: context, controller: this);
  void makeCall() => contactService.makePhoneCall();
  void openWhatsApp() => whatsappService.openWhatsApp();
  void navigateToSignUp(BuildContext context) =>
      Navigator.pushNamed(context, AppRoutes.customerSignup);
  void navigateToCalculator(BuildContext context) =>
      Navigator.pushNamed(context, AppRoutes.purchaseMarket);

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}