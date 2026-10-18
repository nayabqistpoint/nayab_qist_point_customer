import 'package:flutter/material.dart';

class SubmitOrderButtonUi extends StatelessWidget {
  final VoidCallback onSubmit;

  const SubmitOrderButtonUi({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onSubmit,
        icon: const Icon(Icons.send_rounded, size: 16),
        label: const Text('ایڈمن کو باضابطہ آرڈر ارسال کریں'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF059669),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}