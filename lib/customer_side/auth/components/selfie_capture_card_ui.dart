import 'package:flutter/material.dart';

class SelfieCaptureCardUi extends StatelessWidget {
  final bool isUploaded;
  final VoidCallback onTap;

  const SelfieCaptureCardUi({
    super.key,
    required this.isUploaded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isUploaded ? const Color(0xFFECFDF5) : Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: isUploaded ? const Color(0xFF059669) : const Color(0xFFCBD5E1),
          width: 1.1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isUploaded ? const Color(0xFF059669) : const Color(0xFFECFDF5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUploaded ? Icons.check_rounded : Icons.camera_front_rounded,
                color: isUploaded ? Colors.white : const Color(0xFF059669),
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isUploaded ? 'سیلفی کامیابی سے محفوظ ہو گئی' : 'لائیو فرنٹ سیلفی کیپچر',
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    isUploaded ? 'دوبارہ تصویر لینے کیلئے کلک کریں' : 'کیمرہ کے سامنے چہرہ لائیں (بغیر چشمہ و ماسک)',
                    style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              isUploaded ? Icons.refresh_rounded : Icons.add_a_photo_outlined,
              color: const Color(0xFF059669),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}