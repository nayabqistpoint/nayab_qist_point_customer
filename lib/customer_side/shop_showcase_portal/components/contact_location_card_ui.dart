import 'package:flutter/material.dart';

class ContactLocationCardUi extends StatelessWidget {
  final String whatsappNumber;

  const ContactLocationCardUi({
    super.key,
    required this.whatsappNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF86EFAC)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22C55E).withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.support_agent_rounded, color: Color(0xFF16A34A), size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'کسٹمر ہیلپ لائن و فوری واٹس ایپ رابطہ',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            '36 اقساط پلانز، فوری الیکٹرانکس آرڈر یا نئی بکنگ کے لیے رابطہ فرمائیں:',
            style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFF16A34A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.chat_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    whatsappNumber,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}