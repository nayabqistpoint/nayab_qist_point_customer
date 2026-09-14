import 'package:flutter/material.dart';

class LuminousCalculatorBannerUi extends StatelessWidget {
  final VoidCallback onEstimateTap;

  const LuminousCalculatorBannerUi({super.key, required this.onEstimateTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          center: Alignment(-0.8, -0.6),
          radius: 1.4,
          colors: [
            Color(0xFF334155),
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF475569).withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF34D399).withValues(alpha: 0.4)),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF34D399), size: 19),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'اپنی پسند کے موبائل کا قسط پلان بنائیں',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'اگر آپ کا مطلوبہ ماڈل لسٹ میں شامل نہیں، تو نیچے بٹن دبا کر فوری اپنے بجٹ کے مطابق اقساط نکالیں:',
            style: TextStyle(fontSize: 11, color: Color(0xFFFDE68A), height: 1.4, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onEstimateTap,
            icon: const Icon(Icons.touch_app_rounded, size: 15),
            label: const Text('دستی قیمت کا حساب لگائیں (Custom Estimate)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              foregroundColor: Colors.white,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}