import 'package:flutter/material.dart';
import '../../../../core/services/audio_service.dart';
import '../customer_signup_controller.dart';

class AudioRecordTileUi extends StatelessWidget {
  final CustomerSignupController controller;

  const AudioRecordTileUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool hasAudio = controller.isAudioRecorded;
    final bool isRec = controller.isRecording;
    final bool isPlay = controller.isPlayingAudio;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isRec
            ? const Color(0xFFFEF2F2)
            : (hasAudio ? const Color(0xFFF0FDF4) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRec
              ? const Color(0xFFEF4444)
              : (hasAudio ? const Color(0xFF10B981) : const Color(0xFFCBD5E1)),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isRec ? Icons.fiber_manual_record : Icons.mic_rounded,
                color: isRec ? Colors.red : const Color(0xFF0D9488),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isRec
                    ? 'آواز ریکارڈ ہو رہی ہے...'
                    : (hasAudio ? 'آواز ریکارڈ ہو چکی ہے' : 'اقرار نامہ آڈیو ریکارڈ کریں'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isRec ? Colors.red.shade700 : const Color(0xFF0F172A),
                ),
              ),
              const Spacer(),
              if (isRec)
                Text(
                  GlobalAudioService.formatSeconds(GlobalAudioService.recordSeconds),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 10),

          if (!hasAudio)
            ElevatedButton.icon(
              onPressed: controller.toggleAudio,
              icon: Icon(isRec ? Icons.stop_rounded : Icons.mic, size: 18),
              label: Text(isRec ? 'ریکارڈنگ مکمل کریں' : 'ریکارڈنگ شروع کریں'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isRec ? const Color(0xFFDC2626) : const Color(0xFF0D9488),
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(double.infinity, 42),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            )
          else
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF0D9488),
                  radius: 18,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(isPlay ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white),
                    onPressed: controller.togglePlayAudio,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: controller.audioDuration.inMilliseconds > 0
                            ? controller.audioPosition.inMilliseconds / controller.audioDuration.inMilliseconds
                            : 0.0,
                        backgroundColor: Colors.grey.shade300,
                        color: const Color(0xFF0D9488),
                        minHeight: 4,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${controller.formatDuration(controller.audioPosition)} / ${controller.formatDuration(controller.audioDuration)}',
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                  onPressed: controller.deleteAudio,
                ),
              ],
            ),
        ],
      ),
    );
  }
}