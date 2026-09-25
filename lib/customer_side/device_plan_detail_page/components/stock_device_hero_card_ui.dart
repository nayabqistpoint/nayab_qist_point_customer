import 'package:flutter/material.dart';
import 'hero_image_swiper_ui.dart';
import 'device_spec_pills_ui.dart';

class StockDeviceHeroCardUi extends StatelessWidget {
  final Map<String, dynamic> device;
  final List<String> images;

  const StockDeviceHeroCardUi({
    super.key,
    required this.device,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImages = images.isNotEmpty && images.first.trim().isNotEmpty;
    final String imei = device['imeiNo']?.toString() ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        children: [
          if (hasImages)
            HeroImageSwiperUi(images: images)
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Icon(Icons.phone_android_rounded, size: 54, color: Color(0xFF94A3B8)),
            ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device['name'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 8),
                DeviceSpecPillsUi(
                  ramRom: device['ramRom'] ?? '',
                  condition: device['condition'] ?? '',
                  warranty: device['warranty'] ?? 'بغیر وارنٹی',
                ),
                if (imei.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    'IMEI: $imei',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}