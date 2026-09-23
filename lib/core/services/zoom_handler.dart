import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ZoomHandler extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onPick;
  final VoidCallback? onClear;
  final double height;

  const ZoomHandler({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onPick,
    this.onClear,
    this.height = 115,
  });

  bool get hasImage => imagePath.trim().isNotEmpty;

  void _showZoomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Center(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.8,
                maxScale: 4.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _renderImage(fit: BoxFit.contain),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderImage({BoxFit fit = BoxFit.cover}) {
    if (kIsWeb || imagePath.startsWith('blob:') || imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            const Center(child: Icon(Icons.broken_image, color: Colors.red)),
      );
    } else {
      return Image.file(
        File(imagePath),
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            const Center(child: Icon(Icons.broken_image, color: Colors.red)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasImage ? const Color(0xFF0D9488) : const Color(0xFFCBD5E1),
          width: hasImage ? 1.4 : 1.0,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: hasImage ? () => _showZoomDialog(context) : onPick,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!hasImage) ...[
                const Icon(Icons.add_a_photo_outlined, size: 28, color: Color(0xFF0D9488)),
                const SizedBox(height: 6),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569), fontWeight: FontWeight.bold),
                ),
              ] else ...[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: double.infinity,
                      child: _renderImage(),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                    ),
                    InkWell(
                      onTap: onPick,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.refresh, size: 18, color: Color(0xFF0D9488)),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}