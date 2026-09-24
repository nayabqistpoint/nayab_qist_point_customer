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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        children: [
          HeroImageSwiperUi(images: images),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        device['name'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'صرف آسان اقساط پر دستیاب',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DeviceSpecPillsUi(
                  ramRom: device['ramRom'] ?? '',
                  condition: device['condition'] ?? '',
                  warranty: device['warranty'] ?? '12 ماہ آفیشل وارنٹی',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}