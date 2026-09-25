import 'package:flutter/material.dart';

class CustomAdvanceInputBoxUi extends StatefulWidget {
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
  State<CustomAdvanceInputBoxUi> createState() => _CustomAdvanceInputBoxUiState();
}

class _CustomAdvanceInputBoxUiState extends State<CustomAdvanceInputBoxUi> {
  bool get _isInvalid {
    final int val = int.tryParse(widget.controller.text.trim()) ?? 0;
    return val > 0 && val < widget.minAdvanceRequired;
  }

  @override
  Widget build(BuildContext context) {
    final bool invalid = _isInvalid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                    'کم از کم ضروری ایڈوانس: Rs. ${widget.minAdvanceRequired}',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: invalid ? FontWeight.bold : FontWeight.normal,
                      color: invalid ? const Color(0xFFDC2626) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 125,
              height: 38,
              child: TextField(
                controller: widget.controller,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: invalid ? const Color(0xFFDC2626) : const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  prefixText: 'Rs. ',
                  prefixStyle: TextStyle(
                    fontSize: 11,
                    color: invalid ? const Color(0xFFDC2626) : const Color(0xFF64748B),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: invalid ? const Color(0xFFDC2626) : const Color(0xFFCBD5E1),
                      width: invalid ? 1.5 : 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: invalid ? const Color(0xFFDC2626) : const Color(0xFF0D9488),
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (val) {
                  setState(() {});
                  final int v = int.tryParse(val.trim()) ?? 0;
                  if (v == 0 || v >= widget.minAdvanceRequired) {
                    widget.onChanged(v);
                  }
                },
              ),
            ),
          ],
        ),
        if (invalid) ...[
          const SizedBox(height: 4),
          Text(
            'درج کردہ رقم کم از کم ایڈوانس (Rs. ${widget.minAdvanceRequired}) سے کم ہے!',
            style: const TextStyle(fontSize: 9.5, color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
          ),
        ],
      ],
    );
  }
}