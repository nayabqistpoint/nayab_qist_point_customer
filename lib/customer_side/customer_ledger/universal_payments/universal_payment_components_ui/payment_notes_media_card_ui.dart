import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nayab_qist_point_customer/core/services/audio_service.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/universal_payments/universal_payment_controller.dart';

class PaymentNotesMediaCardUi extends StatelessWidget {
  final UniversalPaymentController controller;

  const PaymentNotesMediaCardUi({super.key, required this.controller});

  void _showMediaPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'رسید کی تصویر شامل کریں',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded, color: Color(0xFF0D9488)),
                title: const Text('کیمرہ سے رسید کی تصویر لیں'),
                onTap: () {
                  Navigator.pop(ctx);
                  controller.pickReceiptImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: Color(0xFF2563EB)),
                title: const Text('گیلری یا اسکرین شاٹ چنیں'),
                onTap: () {
                  Navigator.pop(ctx);
                  controller.pickReceiptImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImg = controller.hasReceiptPhoto;
    final bool hasVoice = controller.hasVoiceNote;
    final bool isRec = controller.isRecording;
    final bool isPlay = controller.isPlayingAudio;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.noteCtrl,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'ادائیگی نوٹ یا حوالہ درج کریں...',
                    hintStyle: const TextStyle(fontSize: 11.5),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // کیمرہ بٹن
              InkWell(
                onTap: () => _showMediaPickerSheet(context),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: hasImg ? const Color(0xFFECFDF5) : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: hasImg ? const Color(0xFFA7F3D0) : const Color(0xFFBFDBFE),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    hasImg ? Icons.check_circle_rounded : Icons.camera_alt_rounded,
                    size: 22,
                    color: hasImg ? const Color(0xFF059669) : const Color(0xFF2563EB),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // مائیک بٹن
              InkWell(
                onTap: controller.toggleVoiceRecord,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isRec
                        ? const Color(0xFFFEF2F2)
                        : (hasVoice ? const Color(0xFFECFDF5) : const Color(0xFFF0FDFA)),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isRec
                          ? const Color(0xFFEF4444)
                          : (hasVoice ? const Color(0xFFA7F3D0) : const Color(0xFFCCFBF1)),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    isRec
                        ? Icons.stop_rounded
                        : (hasVoice ? Icons.check_circle_rounded : Icons.mic_rounded),
                    size: 22,
                    color: isRec
                        ? Colors.red
                        : (hasVoice ? const Color(0xFF059669) : const Color(0xFF0D9488)),
                  ),
                ),
              ),
            ],
          ),

          // آڈیو ریکارڈنگ پٹی
          if (isRec) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.fiber_manual_record, color: Colors.red, size: 14),
                const SizedBox(width: 4),
                const Text(
                  'آواز ریکارڈ ہو رہی ہے...',
                  style: TextStyle(fontSize: 10.5, color: Colors.red, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  GlobalAudioService.formatSeconds(GlobalAudioService.recordSeconds),
                  style: const TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ] else if (hasVoice) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isPlay ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: const Color(0xFF0D9488),
                      size: 20,
                    ),
                    onPressed: controller.togglePlayVoice,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'صوتی ریکارڈنگ محفوظ ہے',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                    onPressed: controller.deleteVoiceNote,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ],

          // تصویر کی تصدیق
          if (hasImg) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.image_rounded, size: 13, color: Color(0xFF059669)),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    'رسید کی تصویر منسلک کر دی گئی ہے',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF059669),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InkWell(
                  onTap: controller.removeReceiptImage,
                  child: const Text(
                    'تصویر ہٹائیں',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}