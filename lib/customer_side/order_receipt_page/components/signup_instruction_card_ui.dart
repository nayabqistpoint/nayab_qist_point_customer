import 'package:flutter/material.dart';

class SignupInstructionCardUi extends StatelessWidget {
  const SignupInstructionCardUi({super.key});

  Widget _buildStepRow(String number, String text, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isHighlight ? const Color(0xFF0D9488) : const Color(0xFFE2E8F0),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                color: isHighlight ? Colors.white : const Color(0xFF475569),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10.5,
                height: 1.35,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
                color: isHighlight ? const Color(0xFF047857) : const Color(0xFF334155),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.verified_user_outlined, size: 14, color: Color(0xFFB45309)),
              ),
              const SizedBox(width: 6),
              const Text(
                'اکاؤنٹ اور منظوری کا طریقہ کار:',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildStepRow('1', 'پہلے اپنا مختصر سائن اپ فارم پُر کریں۔'),
          _buildStepRow('2', 'ایڈمن جانچ کے بعد کھاتہ منظور کرے گا۔'),
          _buildStepRow('3', 'آپ کے موبائل کے آخری 4 ہندسے ہی آپ کا پاسورڈ (PIN) ہوں گے۔', isHighlight: true),
        ],
      ),
    );
  }
}