import 'package:flutter/material.dart';

class StockMultiImageCardUi extends StatelessWidget {
  final List<String> images;
  final VoidCallback onAddImage;
  final ValueChanged<String> onRemoveImage;

  const StockMultiImageCardUi({
    super.key,
    required this.images,
    required this.onAddImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('موبائل کی لائیو تصاویر (images):', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
              TextButton.icon(
                onPressed: onAddImage,
                icon: const Icon(Icons.add_a_photo_outlined, size: 16),
                label: const Text('تصویر لیں / شامل کریں'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (images.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('ابھی کوئی تصویر منسلک نہیں کی گئی (کم از کم 1 تصویر تجویز کردہ ہے)', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: images.map((img) => Chip(
                avatar: const Icon(Icons.phone_iphone_rounded, size: 16, color: Color(0xFF1E40AF)),
                label: Text(img, style: const TextStyle(fontSize: 10)),
                onDeleted: () => onRemoveImage(img),
              )).toList(),
            ),
        ],
      ),
    );
  }
}