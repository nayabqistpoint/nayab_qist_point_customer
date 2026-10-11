import 'package:flutter/material.dart';

class AudioAnnouncementBarUi extends StatelessWidget {
  final bool isPlaying;
  final String patronName;
  final String durationText;
  final VoidCallback onTogglePlay;

  const AudioAnnouncementBarUi({
    super.key,
    required this.isPlaying,
    required this.patronName,
    required this.durationText,
    required this.onTogglePlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onTogglePlay,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF334155)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4),
                ],
              ),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: const Color(0xFFFDE68A),
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'صوتی پیغام: $patronName',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      isPlaying ? 'چل رہا ہے...' : durationText,
                      style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '36 اقساط پلانز، فوری الیکٹرانکس فراہمی اور کسٹمر رازداری پالیسی کی تفصیل سنیں',
                  style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}