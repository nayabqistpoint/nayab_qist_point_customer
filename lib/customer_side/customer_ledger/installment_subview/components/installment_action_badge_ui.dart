import 'package:flutter/material.dart';

class InstallmentActionBadgeUi extends StatelessWidget {
  final bool isPaid;
  final bool isUnderReview;
  final bool isDue;
  final bool isPartial;
  final bool isLocked;
  final VoidCallback onTap;

  const InstallmentActionBadgeUi({
    super.key,
    required this.isPaid,
    required this.isUnderReview,
    required this.isDue,
    required this.isPartial,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 1. اگر ایڈمن سے تصدیق شدہ مکمل ادا ہو
    if (isPaid && !isUnderReview) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF86EFAC)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF16A34A)),
            SizedBox(width: 3),
            Text(
              'مکمل ادا',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
            ),
          ],
        ),
      );
    }

    // 2. اگر رسید جمع ہے اور ایڈمن تصدیق کا انتظار ہے (کوئی بٹن نہیں، صرف زرد بیج)
    if (isUnderReview) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFFCD34D)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hourglass_top_rounded, size: 11, color: Color(0xFFD97706)),
            SizedBox(width: 3),
            Text(
              'زیرِ جائزہ',
              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
            ),
          ],
        ),
      );
    }

    // 3. اگر کھاتہ فریز یا مقفل ہو
    if (isLocked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline_rounded, size: 11, color: Color(0xFF94A3B8)),
            SizedBox(width: 3),
            Text(
              'مقفل',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      );
    }

    // 4. صرف اس وقت فعال ہوگا جب کوئی پینڈنگ ریویو نہ ہو اور یہ پہلی واجب قسط ہو
    final Color btnColor = (isDue || isPartial) ? const Color(0xFFDC2626) : const Color(0xFF1E293B);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.payment_rounded, size: 11, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                isDue ? 'واجب ادا کریں' : 'ادائیگی کریں',
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}