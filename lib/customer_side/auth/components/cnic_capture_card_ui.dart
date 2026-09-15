import 'package:flutter/material.dart';

class CnicCaptureCardUi extends StatelessWidget {
  final String label;
  final IconData icon;
  final String hint;
  final bool isUploaded;
  final VoidCallback onTap;

  const CnicCaptureCardUi({
    super.key,
    required this.label,
    required this.icon,
    required this.hint,
    required this.isUploaded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98,
      decoration: BoxDecoration(
        color: isUploaded ? const Color(0xFFECFDF5) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: isUploaded ? const Color(0xFF059669) : const Color(0xFF059669).withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: isUploaded ? const Color(0xFF059669) : const Color(0xFF34D399)),
              ),
              child: Icon(
                isUploaded ? Icons.check_circle_rounded : icon,
                color: const Color(0xFF059669),
                size: 20,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1),
            Text(
              isUploaded ? 'تصویر محفوظ ہو گئی' : hint,
              style: TextStyle(fontSize: 8.5, color: isUploaded ? const Color(0xFF059669) : const Color(0xFF64748B)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}