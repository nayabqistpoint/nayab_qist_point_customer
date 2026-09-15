import 'package:flutter/material.dart';
import '../customer_signup_controller.dart';
import 'cnic_capture_card_ui.dart';
import 'selfie_capture_card_ui.dart';
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
        Row(
          children: [
            Expanded(
              child: CnicCaptureCardUi(
                label: 'شناختی کارڈ فرنٹ',
                icon: Icons.badge_outlined,
                hint: 'سامنے کا حصہ لیں',
                isUploaded: controller.isCnicFrontUploaded,
                onTap: controller.toggleCnicFront,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CnicCaptureCardUi(
                label: 'شناختی کارڈ بیک',
                icon: Icons.badge_rounded,
                hint: 'پیچھے کا حصہ لیں',
                isUploaded: controller.isCnicBackUploaded,
                onTap: controller.toggleCnicBack,
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),
        SelfieCaptureCardUi(
          isUploaded: controller.isSelfieUploaded,
          onTap: controller.toggleSelfie,
        ),
        const SizedBox(height: 13),
        AudioRecordTileUi(
          isRecorded: controller.isAudioRecorded,
          onToggleRecord: controller.toggleAudio,
        ),
      ],
    );
  }
}