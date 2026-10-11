import 'package:flutter/material.dart';

class MediaShowcaseRowUi extends StatelessWidget {
  final List<Map<String, dynamic>> mediaList;

  const MediaShowcaseRowUi({
    super.key,
    required this.mediaList,
  });

  @override
  Widget build(BuildContext context) {
    if (mediaList.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.video_library_rounded, color: Color(0xFF0D9488), size: 18),
                  SizedBox(width: 6),
                  Text(
                    'سیل کٹ و ہینڈ اوور ویڈیوز (پرائیویسی پروٹیکٹڈ)',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              Text('لائیو ریکارڈ', style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: mediaList.map((item) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _videoThumbnailCard(
                    item['title']?.toString() ?? '',
                    item['token']?.toString() ?? '',
                    item['duration']?.toString() ?? '',
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          const Text(
            '📌 ویڈیوز میں کسٹمر کا چہرہ دکھائے بغیر صرف اوریجنل پروڈکٹ، سیل کٹ اور ڈبہ دکھایا جاتا ہے۔',
            style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  static Widget _videoThumbnailCard(String title, String token, String duration) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow_rounded, color: Color(0xFFFDE68A), size: 20),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold),
              ),
              Text(token, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 8.5)),
            ],
          ),
          Positioned(
            bottom: 4,
            right: 6,
            child: Text(duration, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 8)),
          ),
        ],
      ),
    );
  }
}