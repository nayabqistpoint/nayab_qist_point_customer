import 'package:flutter/material.dart';

class AudioRecordTileUi extends StatelessWidget {
  final bool isRecorded;
  final VoidCallback onToggleRecord;

  const AudioRecordTileUi({
    super.key,
    required this.isRecorded,
    required this.onToggleRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isRecorded ? const Color(0xFFECFDF5) : Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: isRecorded ? const Color(0xFF059669) : const Color(0xFFCBD5E1),
          width: 1.1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isRecorded ? const Color(0xFF059669) : const Color(0xFFDC2626),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isRecorded ? Icons.check_rounded : Icons.mic_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRecorded ? 'زبانی بیان ریکارڈ ہو گیا (0:05s)' : 'زبانی بیان / وائس ریکارڈنگ',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    color: isRecorded ? const Color(0xFF065F46) : const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  isRecorded ? 'دوبارہ ریکارڈ کرنے کیلئے بٹن دبائیں' : 'مائیک دبا کر اقساط کی پابندی کا اقرار کریں',
                  style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onToggleRecord,
            style: ElevatedButton.styleFrom(
              backgroundColor: isRecorded ? const Color(0xFF059669) : const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              elevation: 0,
            ),
            child: Text(
              isRecorded ? 'دوبارہ سنیں' : 'ریکارڈ کریں',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}