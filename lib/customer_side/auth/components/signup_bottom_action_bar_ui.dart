import 'package:flutter/material.dart';

class SignupBottomActionBarUi extends StatelessWidget {
  final int currentStep;
  final VoidCallback onBack;
  final VoidCallback onNextOrSubmit;

  const SignupBottomActionBarUi({
    super.key,
    required this.currentStep,
    required this.onBack,
    required this.onNextOrSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLastStep = currentStep == 2;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          // 🔙 پیچھے والا بٹن (نوک دائیں طرف > رہے گی)
          if (currentStep > 0)
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF475569),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    ),
                    SizedBox(width: 5),
                    Text('پیچھے', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 8),

          // 🚀 اگلا مرحلہ بٹن (نوک بالکل اوپر والے شیورون تیروں کی طرح بائیں طرف < رہے گی)
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onNextOrSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLastStep)
                    const Icon(Icons.check_circle_outline_rounded, size: 16)
                  else
                    const Directionality(
                      textDirection: TextDirection.ltr,
                      child: Icon(Icons.arrow_back_ios_new_rounded, size: 14),
                    ),
                  const SizedBox(width: 6),
                  Text(
                    isLastStep ? 'درخواست جمع کریں' : 'اگلا مرحلہ',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}