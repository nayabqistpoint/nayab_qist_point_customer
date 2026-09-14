import 'package:flutter/material.dart';

class CustomAdvanceInputBoxUi extends StatelessWidget {
  final int minAdvanceRequired;
  final TextEditingController controller;
  final Function(int) onChanged;

  const CustomAdvanceInputBoxUi({
    super.key,
    required this.minAdvanceRequired,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ایڈوانس رقم تبدیل کریں (قسط کم کرنے کے لیے):',
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 2),
              Text(
                'کم از کم ضروری ایڈوانس: Rs. $minAdvanceRequired',
                style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 120,
          height: 38,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixText: 'Rs. ',
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: (val) {
              final int v = int.tryParse(val.trim()) ?? 0;
              onChanged(v);
            },
          ),
        ),
      ],
    );
  }
}