import 'package:flutter/material.dart';

class CustomerContactUi extends StatelessWidget {
  final VoidCallback onCallPressed;
  final VoidCallback onWhatsAppPressed;

  const CustomerContactUi({super.key, required this.onCallPressed, required this.onWhatsAppPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 390),
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.3))),
      child: Column(
        children: [
          const Text(':معلومات یا پاسورڈ کے لیے رابطہ کریں', style: TextStyle(fontSize: 12, color: Colors.white70)),
          const Text('حافظ محمد صابر - 03012700351', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: ElevatedButton.icon(onPressed: onCallPressed, icon: const Icon(Icons.phone, size: 16), label: const Text('کال کریں'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600], foregroundColor: Colors.white))),
              const SizedBox(width: 8),
              Expanded(child: ElevatedButton.icon(onPressed: onWhatsAppPressed, icon: const Icon(Icons.chat, size: 16), label: const Text('واٹس ایپ'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF075E54), foregroundColor: Colors.white))),
            ],
          ),
        ],
      ),
    );
  }
}