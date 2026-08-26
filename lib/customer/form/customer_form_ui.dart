import 'package:flutter/material.dart';

class CustomerFormUi extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool rememberMe;
  final VoidCallback onTogglePasswordVisibility;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onFingerprintTap;
  final VoidCallback onLoginPressed;

  const CustomerFormUi({
    super.key,
    required this.phoneController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.rememberMe,
    required this.onTogglePasswordVisibility,
    required this.onRememberMeChanged,
    required this.onFingerprintTap,
    required this.onLoginPressed,
  });

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
            controller: phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: 'موبائل نمبر',
              labelStyle: const TextStyle(color: Colors.white70, fontSize: 13),
              prefixIcon: const Icon(Icons.phone_android, color: Colors.white, size: 20),
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.2),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: 'پاسورڈ (PIN)',
                    labelStyle: const TextStyle(color: Colors.white70, fontSize: 13),
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.white, size: 20),
                    suffixIcon: IconButton(
                      iconSize: 20,
                      icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
                      onPressed: onTogglePasswordVisibility,
                    ),
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.2),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 50, height: 50,
                child: InkWell(
                  onTap: onFingerprintTap,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.red[800], borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.5))),
                    child: const Icon(Icons.fingerprint, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              SizedBox(height: 24, width: 24, child: Checkbox(value: rememberMe, activeColor: Colors.red[700], checkColor: Colors.white, side: const BorderSide(color: Colors.white), onChanged: onRememberMeChanged)),
              const SizedBox(width: 8),
              const Text('پاسورڈ یاد رکھیں', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity, height: 46,
            child: ElevatedButton(
              onPressed: onLoginPressed,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800], foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('کسٹمر ڈیش بورڈ کھولیں', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}