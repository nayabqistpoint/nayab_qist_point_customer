import 'package:flutter/material.dart';
import '../universal_payment_controller.dart';

class PaymentNotesMediaCardUi extends StatelessWidget {
  final UniversalPaymentController controller;
  final VoidCallback onStateChange;

  const PaymentNotesMediaCardUi({
    super.key,
    required this.controller,
    required this.onStateChange,
  });

  Widget _mediaBtn({required bool active, required IconData icon, required Color c, required Color bg, required Color bdr, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFECFDF5) : bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? const Color(0xFFA7F3D0) : bdr, width: 1.2),
        ),
        child: Icon(active ? Icons.check_circle_rounded : icon, size: 22, color: active ? const Color(0xFF059669) : c),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller.noteCtrl,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'تفصیلی ڈسکرپشن یا ادائیگی نوٹ درج کریں...',
                hintStyle: const TextStyle(fontSize: 11.5),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _mediaBtn(
            active: controller.hasPhoto,
            icon: Icons.camera_alt_rounded,
            c: const Color(0xFF2563EB),
            bg: const Color(0xFFEFF6FF),
            bdr: const Color(0xFFBFDBFE),
            onTap: () {
              controller.hasPhoto = !controller.hasPhoto;
              onStateChange();
            },
          ),
          const SizedBox(width: 8),
          _mediaBtn(
            active: controller.hasAudio,
            icon: Icons.mic_rounded,
            c: const Color(0xFF0D9488),
            bg: const Color(0xFFF0FDFA),
            bdr: const Color(0xFFCCFBF1),
            onTap: () {
              controller.hasAudio = !controller.hasAudio;
              onStateChange();
            },
          ),
        ],
      ),
    );
  }
}