import 'package:flutter/material.dart';

class GracePeriodNoteUi extends StatelessWidget {
  const GracePeriodNoteUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'نوٹ: اگر تاریخ درخواست سے آنے والی 5 تاریخ میں 15 دن سے کم وقفہ ہو تو پہلی قسط اگلے ماہ کی 5 تاریخ سے شروع ہو گی۔',
        style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B), height: 1.3),
      ),
    );
  }
}