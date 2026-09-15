import 'package:flutter/material.dart';
import '../customer_login_controller.dart';
import 'login_remember_me_ui.dart';
import 'login_action_button_ui.dart';

class LoginFormUi extends StatelessWidget {
  final CustomerLoginController controller;

  const LoginFormUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 390),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: 'موبائل نمبر',
              labelStyle: const TextStyle(color: Colors.white70, fontSize: 13),
              prefixIcon: const Icon(Icons.phone_android, color: Colors.white, size: 20),
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.2),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.redAccent, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: 'پاسورڈ (PIN)',
                    labelStyle: const TextStyle(color: Colors.white70, fontSize: 13),
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.white, size: 20),
                    suffixIcon: IconButton(
                      iconSize: 20,
                      icon: Icon(
                        controller.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.2),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 50,
                height: 50,
                child: InkWell(
                  onTap: () => controller.triggerBiometric(context),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red[800],
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                    ),
                    child: const Icon(Icons.fingerprint, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LoginRememberMeUi(
            rememberMe: controller.rememberMe,
            onRememberMeChanged: controller.setRememberMe,
          ),
          const SizedBox(height: 10),
          LoginActionButtonUi(
            onPressed: () => controller.submitLogin(context),
          ),
        ],
      ),
    );
  }
}