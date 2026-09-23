import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionService {
  /// کیمرہ پرمیشن
  static Future<bool> requestCameraPermission() async {
    if (kIsWeb) return true;

    try {
      final status = await Permission.camera.status;
      if (status.isGranted) return true;

      final result = await Permission.camera.request();
      if (result.isGranted) return true;

      if (result.isPermanentlyDenied) {
        debugPrint('⚠️ کیمرہ پرمیشن بند ہے، ایپ سیٹنگز کھولیں');
        await openAppSettings();
      }
      return false;
    } catch (e) {
      debugPrint('❌ کیمرہ پرمیشن ایرر: $e');
      return false;
    }
  }

  /// گیلری / میڈیا پرمیشن
  static Future<bool> requestGalleryPermission() async {
    if (kIsWeb) return true;

    try {
      final photosStatus = await Permission.photos.status;
      final storageStatus = await Permission.storage.status;

      if (photosStatus.isGranted || storageStatus.isGranted) return true;

      final resultPhotos = await Permission.photos.request();
      if (resultPhotos.isGranted) return true;

      final resultStorage = await Permission.storage.request();
      return resultStorage.isGranted;
    } catch (e) {
      debugPrint('❌ گیلری پرمیشن ایرر: $e');
      return false;
    }
  }

  /// آڈیو / مائیک پرمیشن
  static Future<bool> requestAudioPermission() async {
    if (kIsWeb) return true;

    try {
      final status = await Permission.microphone.status;
      if (status.isGranted) return true;

      final result = await Permission.microphone.request();
      if (result.isGranted) return true;

      if (result.isPermanentlyDenied) {
        debugPrint('⚠️ مائیک پرمیشن بند ہے، ایپ سیٹنگز کھولیں');
        await openAppSettings();
      }
      return false;
    } catch (e) {
      debugPrint('❌ مائیک پرمیشن ایرر: $e');
      return false;
    }
  }
}