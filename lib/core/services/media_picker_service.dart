import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nayab_qist_point_customer/core/services/app_permission_service.dart';
import 'package:nayab_qist_point_customer/core/services/local_media_helper.dart';

class MediaPickerService {
  static final ImagePicker _picker = ImagePicker();

  /// کسی بھی مقصد کے لیے جنرل امیج کیپچر (کیمرہ یا گیلری)
  static Future<String?> pickImage({
    required ImageSource source,
    bool isSelfie = false,
    String subFolder = 'general_media',
  }) async {
    try {
      final bool hasPerm = source == ImageSource.camera
          ? await AppPermissionService.requestCameraPermission()
          : await AppPermissionService.requestGalleryPermission();

      if (!hasPerm) {
        debugPrint('⚠️ مطلوبہ پرمیشن نہیں ملی');
        return null;
      }

      final XFile? file = await _picker.pickImage(
        source: source,
        preferredCameraDevice: isSelfie ? CameraDevice.front : CameraDevice.rear,
        imageQuality: isSelfie ? 75 : 80,
      );

      if (file == null) {
        return null;
      }

      // مستقل لوکل میموری میں محفوظ کریں
      return await LocalMediaHelper.savePermanently(
        file.path,
        subFolder: subFolder,
      );
    } catch (e) {
      debugPrint('❌ MediaPickerService Error: $e');
      return null;
    }
  }

  /// دستاویزات کے لیے (بیک کیمرہ یا گیلری)
  static Future<String?> pickDocument({
    required ImageSource source,
    String subFolder = 'documents',
  }) async {
    return await pickImage(source: source, isSelfie: false, subFolder: subFolder);
  }

  /// لائیو سیلفی کے لیے (صرف فرنٹ کیمرہ)
  static Future<String?> pickSelfie({
    String subFolder = 'selfies',
  }) async {
    return await pickImage(source: ImageSource.camera, isSelfie: true, subFolder: subFolder);
  }
}