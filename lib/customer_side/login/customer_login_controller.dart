import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';
import 'services/login_auth_service.dart';
import 'services/login_biometric_service.dart';
import 'services/login_storage_service.dart';
import 'services/login_contact_service.dart';
import 'services/login_whatsapp_service.dart';

class CustomerLoginController extends ChangeNotifier {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool rememberMe = false;

  // آزاد سروسز کے انسٹینس
  final authService = LoginAuthService();
  final biometricService = LoginBiometricService();
  final storageService = LoginStorageService();
  final contactService = LoginContactService();
  final whatsappService = LoginWhatsappService();

  Future<void> initSavedCredentials() async {
    final creds = await storageService.loadSavedCredentials();
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

  void submitLogin(BuildContext context) {
    authService.performLogin(
      context: context,
      phone: phoneController.text,
      password: passwordController.text,
      rememberMe: rememberMe,
    );
  }

  void triggerBiometric(BuildContext context) {
    biometricService.authenticateAndLogin(
      context: context,
      authService: authService,
    );
  }

  void makeCall() => contactService.makePhoneCall();

  void openWhatsApp() => whatsappService.openWhatsApp();

  void navigateToSignUp(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.customerSignup);
  }

  void navigateToCalculator(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.purchaseMarket);
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}