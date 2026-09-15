import 'package:flutter/material.dart';

class LoginRememberMeUi extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;

  const LoginRememberMeUi({
    super.key,
    required this.rememberMe,
    required this.onRememberMeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: rememberMe,
            activeColor: Colors.red[700],
            checkColor: Colors.white,
            side: const BorderSide(color: Colors.white),
            onChanged: onRememberMeChanged,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'پاسورڈ یاد رکھیں',
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}