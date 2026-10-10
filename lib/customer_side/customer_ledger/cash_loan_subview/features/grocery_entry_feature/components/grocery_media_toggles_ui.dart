import 'package:flutter/material.dart';

class GroceryMediaTogglesUi extends StatelessWidget {
  final bool hasPhoto;
  final bool hasAudio;
  final ValueChanged<bool?> onPhotoChanged;
  final ValueChanged<bool?> onAudioChanged;

  const GroceryMediaTogglesUi({
    super.key,
    required this.hasPhoto,
    required this.hasAudio,
    required this.onPhotoChanged,
    required this.onAudioChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CheckboxListTile(
            value: hasPhoto,
            onChanged: onPhotoChanged,
            title: const Text('پرچی / بل کی تصویر', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            secondary: const Icon(Icons.camera_alt_outlined, size: 18),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        Expanded(
          child: CheckboxListTile(
            value: hasAudio,
            onChanged: onAudioChanged,
            title: const Text('وائس تصدیق نوٹ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            secondary: const Icon(Icons.mic_none_rounded, size: 18),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}