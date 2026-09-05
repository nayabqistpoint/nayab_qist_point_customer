import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class CustomerProfileImageService {
  /// Base64 یا Cloudinary URL کو خودکار تشخیص کر کے Widget واپس کرتا ہے
  static Widget buildProfileImage(String? imageSource, {double radius = 16}) {
    // اگر تصویر کا ڈیٹا موجود نہ ہو تو ڈیفالٹ پرسن آئیکن دکھائیں
    if (imageSource == null || imageSource.trim().isEmpty) {
      return _buildDefaultAvatar(radius);
    }

    final cleanSource = imageSource.trim();

    try {
      // ۱۔ اگر Base64 سٹرنگ ہو
      if (_isBase64(cleanSource)) {
        String base64Data = cleanSource;
        if (cleanSource.contains(',')) {
          base64Data = cleanSource.split(',').last;
        }
        final Uint8List bytes = base64Decode(base64Data);
        return CircleAvatar(
          radius: radius,
          backgroundImage: MemoryImage(bytes),
        );
      }

      // ۲۔ اگر Cloudinary یا کوئی اور نیٹ ورک URL ہو
      if (cleanSource.startsWith('http://') || cleanSource.startsWith('https://')) {
        return CircleAvatar(
          radius: radius,
          backgroundImage: NetworkImage(cleanSource),
          child: const SizedBox.shrink(),
        );
      }
    } catch (e) {
      debugPrint("تصویر لوڈ کرنے میں غلطی: $e");
    }

    // اگر کوئی خرابی آئے تو ڈیفالٹ آئیکن دکھائیں
    return _buildDefaultAvatar(radius);
  }

  /// Base64 کی تشخیص کے لیے ہیلپر
  static bool _isBase64(String str) {
    if (str.startsWith('data:image') || str.contains(';base64,')) {
      return true;
    }
    // عام Base64 پیٹرن کی جانچ
    final RegExp base64RegExp = RegExp(r'^[A-Za-z0-9+/=]+$');
    return str.length % 4 == 0 && base64RegExp.hasMatch(str);
  }

  /// ڈیفالٹ پرسن آئیکن
  static Widget _buildDefaultAvatar(double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white24,
      child: Icon(Icons.person, size: radius * 1.25, color: Colors.white),
    );
  }
}