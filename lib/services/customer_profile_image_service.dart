import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomerProfileImageService {
  /// Base64 یا Cloudinary URL کو کلک ایبل اوتار کے ساتھ دکھاتا ہے
  static Widget buildProfileImage(
    BuildContext context,
    String? imageSource, {
    double radius = 16,
  }) {
    final Widget avatarWidget = _buildAvatarWidget(imageSource, radius);

    // اگر تصویر کا ڈیٹا موجود ہے تو اسے کلک ایبل بنائیں
    if (imageSource != null && imageSource.trim().isNotEmpty) {
      return GestureDetector(
        onTap: () => showFullScreenImage(context, imageSource),
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }

  /// فل اسکرین میں تصویر دکھانے کا فنکشن (زوم اور کلوز بٹن کے ساتھ)
  static void showFullScreenImage(BuildContext context, String imageSource) {
    final cleanSource = imageSource.trim();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ۱۔ تصویر پر زوم ان / زوم آؤٹ کرنے کا آپشن
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: _buildFullImageWidget(cleanSource),
            ),

            // ۲۔ بند کرنے کے لیے کراس (Close) کا بٹن
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🟢 اوتار وزٹ (آف لائن کیشنگ کے ساتھ)
  static Widget _buildAvatarWidget(String? imageSource, double radius) {
    if (imageSource == null || imageSource.trim().isEmpty) {
      return _buildDefaultAvatar(radius);
    }

    final cleanSource = imageSource.trim();

    try {
      if (_isBase64(cleanSource)) {
        String base64Data = cleanSource.contains(',') ? cleanSource.split(',').last : cleanSource;
        final Uint8List bytes = base64Decode(base64Data);
        return CircleAvatar(radius: radius, backgroundImage: MemoryImage(bytes));
      }

      if (cleanSource.startsWith('http://') || cleanSource.startsWith('https://')) {
        return CachedNetworkImage(
          imageUrl: cleanSource,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: radius,
            backgroundImage: imageProvider,
          ),
          placeholder: (context, url) => CircleAvatar(
            radius: radius,
            backgroundColor: Colors.white24,
            child: SizedBox(
              width: radius,
              height: radius,
              child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
          ),
          errorWidget: (context, url, error) => _buildDefaultAvatar(radius),
        );
      }
    } catch (_) {}

    return _buildDefaultAvatar(radius);
  }

  /// 🟢 فل اسکرین وزٹ (آف لائن کیشنگ کے ساتھ)
  static Widget _buildFullImageWidget(String cleanSource) {
    try {
      if (_isBase64(cleanSource)) {
        String base64Data = cleanSource.contains(',') ? cleanSource.split(',').last : cleanSource;
        final Uint8List bytes = base64Decode(base64Data);
        return Image.memory(bytes, fit: BoxFit.contain);
      }

      if (cleanSource.startsWith('http://') || cleanSource.startsWith('https://')) {
        return CachedNetworkImage(
          imageUrl: cleanSource,
          fit: BoxFit.contain,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.broken_image,
            color: Colors.white,
            size: 60,
          ),
        );
      }
    } catch (_) {}

    return const Icon(Icons.person, color: Colors.white, size: 100);
  }

  static bool _isBase64(String str) {
    if (str.startsWith('data:image') || str.contains(';base64,')) return true;
    final RegExp base64RegExp = RegExp(r'^[A-Za-z0-9+/=]+$');
    return str.length % 4 == 0 && base64RegExp.hasMatch(str);
  }

  static Widget _buildDefaultAvatar(double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white24,
      child: Icon(Icons.person, size: radius * 1.25, color: Colors.white),
    );
  }
}