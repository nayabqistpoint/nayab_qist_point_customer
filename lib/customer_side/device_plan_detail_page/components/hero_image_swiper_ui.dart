import 'package:flutter/material.dart';
import 'full_screen_zoom_gallery_ui.dart';

class HeroImageSwiperUi extends StatelessWidget {
  final List<String> images;

  const HeroImageSwiperUi({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            itemCount: images.isNotEmpty ? images.length : 1,
            itemBuilder: (ctx, i) {
              final String url = images.isNotEmpty ? images[i] : '';
              return InkWell(
                onTap: () => FullScreenZoomGalleryUi.show(context, i, images),
                child: Container(
                  color: const Color(0xFFF8FAFC),
                  child: Image.network(
                    url,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.phone_android_rounded, size: 70, color: Color(0xFF0D9488)),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 8,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.zoom_in_rounded, size: 12, color: Colors.white),
                SizedBox(width: 4),
                Text('بڑی تصویر دیکھنے کے لیے ٹیپ کریں', style: TextStyle(color: Colors.white, fontSize: 9.5)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}