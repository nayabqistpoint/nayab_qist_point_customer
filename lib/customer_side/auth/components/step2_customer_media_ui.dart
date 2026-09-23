import 'package:flutter/material.dart';
import '../../../../core/services/zoom_handler.dart';
import '../customer_signup_controller.dart';
import 'audio_record_tile_ui.dart';

class Step2CustomerMediaUi extends StatelessWidget {
  final CustomerSignupController controller;

  const Step2CustomerMediaUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ڈیجیٹل تصدیق و دستاویزات',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 2),
        const Text(
          'کارڈ اور چہرہ بالکل صاف فریم میں ہونا چاہیے',
          style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 14),

        // ۱. کسٹمر شناختی کارڈ فرنٹ اور بیک
        Row(
          children: [
            Expanded(
              child: ZoomHandler(
                title: 'شناختی کارڈ فرنٹ',
                imagePath: controller.media.cnicFront,
                onPick: controller.toggleCnicFront,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ZoomHandler(
                title: 'شناختی کارڈ بیک',
                imagePath: controller.media.cnicBack,
                onPick: controller.toggleCnicBack,
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),

        // ۲. کسٹمر لائیو سیلفی
        ZoomHandler(
          title: 'لائیو فرنٹ سیلفی',
          imagePath: controller.media.selfie,
          onPick: controller.toggleSelfie,
          height: 120,
        ),
        const SizedBox(height: 13),

        // ۳. آڈیو ریکارڈنگ ٹائل (کنٹرولر پاس ہو گیا)
        AudioRecordTileUi(controller: controller),
      ],
    );
  }
}