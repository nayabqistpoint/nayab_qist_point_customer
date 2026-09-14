import 'package:flutter/material.dart';
import '../service_stock_controller.dart';

class NoteMediaBarUi extends StatelessWidget {
  final ServiceStockController controller;

  const NoteMediaBarUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller.noteCtrl,
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              hintText: 'تفصیلی ڈسکرپشن یا نوٹ درج کریں...',
              hintStyle: const TextStyle(fontSize: 11.5),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => controller.togglePhoto(),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: controller.hasPhoto ? const Color(0xFFECFDF5) : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: controller.hasPhoto ? const Color(0xFFA7F3D0) : const Color(0xFFBFDBFE),
                width: 1.2,
              ),
            ),
            child: Icon(
              controller.hasPhoto ? Icons.check_circle_rounded : Icons.camera_alt_rounded,
              size: 22,
              color: controller.hasPhoto ? const Color(0xFF059669) : const Color(0xFF2563EB),
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => controller.toggleAudio(),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: controller.hasAudio ? const Color(0xFFECFDF5) : const Color(0xFFF0FDFA),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: controller.hasAudio ? const Color(0xFFA7F3D0) : const Color(0xFFCCFBF1),
                width: 1.2,
              ),
            ),
            child: Icon(
              controller.hasAudio ? Icons.check_circle_rounded : Icons.mic_rounded,
              size: 22,
              color: controller.hasAudio ? const Color(0xFF059669) : const Color(0xFF0D9488),
            ),
          ),
        ),
      ],
    );
  }
}