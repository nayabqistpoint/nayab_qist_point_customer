import 'package:flutter/material.dart';

class LuminousCalculatorBannerUi extends StatelessWidget {
  final VoidCallback onEstimateTap;

  const LuminousCalculatorBannerUi({
    super.key,
    required this.onEstimateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // 🌟 اوپر اور نیچے کی پیڈنگ بڑھا کر 24 کر دی ہے تاکہ بینر موٹا اور کشادہ رہے
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          center: Alignment(-0.8, -0.6),
          radius: 1.5,
          colors: [
            Color(0xFF334155),
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF475569).withValues(alpha: 0.6),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF34D399).withValues(alpha: 0.5)),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF34D399), size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'اپنی پسند کے موبائل کا قسط پلان بنائیں',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'اگر آپ کا مطلوبہ ماڈل لسٹ میں شامل نہیں، تو نیچے بٹن دبا کر فوری اپنے بجٹ کے مطابق اقساط نکالیں:',
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFFFDE68A),
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onEstimateTap,
              icon: const Icon(Icons.touch_app_rounded, size: 20),
              label: const Text(
                'اپنی مرضی کی قیمت کا حساب لگائیں',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}