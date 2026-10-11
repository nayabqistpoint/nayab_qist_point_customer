import 'package:flutter/material.dart';

class ShareNoticeCardUi extends StatelessWidget {
  final VoidCallback onSharePressed;

  const ShareNoticeCardUi({
    super.key,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSharePressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle),
                child: const Icon(Icons.share_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'دوستوں کو نایاب قسط پوائنٹ شیڈول بھیجیں',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: Color(0xFF1E40AF)),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'واٹس ایپ پر اپنے دوستوں اور رشتہ داروں کے ساتھ دکان کی آفرز شیئر کریں',
                      style: TextStyle(fontSize: 9.5, color: Color(0xFF3B82F6)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF2563EB)),
            ],
          ),
        ),
      ),
    );
  }
}