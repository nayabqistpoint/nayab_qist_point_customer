import 'package:flutter/material.dart';

class LiveMetricsRibbonUi extends StatelessWidget {
  final int totalQuota;
  final int deliveredCount;

  const LiveMetricsRibbonUi({
    super.key,
    required this.totalQuota,
    required this.deliveredCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _metricTile('$totalQuota میں سے $deliveredCount', 'موبائل کوٹہ ترسیل', Icons.phone_android_rounded, const Color(0xFF0D9488), const Color(0xFFF0FDFA)),
        const SizedBox(width: 8),
        _metricTile('24 گھنٹے', 'الیکٹرانکس ڈلیوری', Icons.electric_bolt_rounded, const Color(0xFFD97706), const Color(0xFFFFFBEB)),
        const SizedBox(width: 8),
        _metricTile('100% محفوظ', 'رازداری گارنٹی', Icons.security_rounded, const Color(0xFF16A34A), const Color(0xFFF0FDF4)),
      ],
    );
  }

  Widget _metricTile(String val, String sub, IconData icon, Color accent, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, size: 16, color: accent),
            ),
            const SizedBox(height: 5),
            Text(val, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: accent)),
            const SizedBox(height: 2),
            Text(
              sub,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}