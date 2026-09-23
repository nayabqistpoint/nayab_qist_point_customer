import 'package:flutter/foundation.dart';
import '../../hive_services/hive_box_manager.dart';
import '../core/connectivity_service.dart';
import 'cloudinary_upload_service.dart';

class PendingMediaSyncService {
  static Future<void> processPendingUploads() async {
    debugPrint('🚀 [PendingMediaSyncService] میڈیا اپلوڈ کی جانچ شروع...');

    if (!kIsWeb) {
      final isOnline = await ConnectivityService.hasInternetConnection();
      if (!isOnline) {
        debugPrint('⚠️ انٹرنیٹ موجود نہیں ہے');
        return;
      }
    }

    final box = await HiveBoxManager.openSafeBox(HiveBoxManager.mediaBoxName);

    for (var key in box.keys) {
      final raw = box.get(key);
      if (raw is Map) {
        final data = Map<String, dynamic>.from(raw);

        // صرف ان کو پروسیس کریں جو واقعی پینڈنگ ہیں
        if (data['status'] == 'pending_upload') {
          bool allSuccess = true;

          bool needsUpload(dynamic val) {
            final str = (val ?? '').toString().trim();
            if (str.isEmpty) return false;
            if (str.startsWith('https://res.cloudinary.com')) return false;
            return str.startsWith('blob:') || str.startsWith('/') || str.startsWith('http');
          }

          // ۱. کسٹمر فرنٹ کارڈ
          if (needsUpload(data['customerCnicFront'])) {
            debugPrint('📤 کلاؤڈینیری: کسٹمر فرنٹ کارڈ جا رہا ہے...');
            final url = await CloudinaryUploadService.uploadFile(data['customerCnicFront'], isAudio: false);
            if (url != null) {
              data['customerCnicFront'] = url;
            } else {
              allSuccess = false;
            }
          }

          // ۲. کسٹمر بیک کارڈ
          if (needsUpload(data['customerCnicBack'])) {
            debugPrint('📤 کلاؤڈینیری: کسٹمر بیک کارڈ جا رہا ہے...');
            final url = await CloudinaryUploadService.uploadFile(data['customerCnicBack'], isAudio: false);
            if (url != null) {
              data['customerCnicBack'] = url;
            } else {
              allSuccess = false;
            }
          }

          // ۳. کسٹمر سیلفی
          if (needsUpload(data['customerSelfie'])) {
            debugPrint('📤 کلاؤڈینیری: کسٹمر سیلفی جا رہی ہے...');
            final url = await CloudinaryUploadService.uploadFile(data['customerSelfie'], isAudio: false);
            if (url != null) {
              data['customerSelfie'] = url;
            } else {
              allSuccess = false;
            }
          }

          // ۴. کسٹمر آڈیو
          if (needsUpload(data['customerAudio'])) {
            debugPrint('📤 کلاؤڈینیری: کسٹمر آڈیو جا رہی ہے...');
            final url = await CloudinaryUploadService.uploadFile(data['customerAudio'], isAudio: true);
            if (url != null) {
              data['customerAudio'] = url;
            } else {
              allSuccess = false;
            }
          }

          // ۵. ضامن فرنٹ کارڈ
          if (needsUpload(data['guarantorCnicFront'])) {
            debugPrint('📤 کلاؤڈینیری: ضامن فرنٹ کارڈ جا رہا ہے...');
            final url = await CloudinaryUploadService.uploadFile(data['guarantorCnicFront'], isAudio: false);
            if (url != null) {
              data['guarantorCnicFront'] = url;
            } else {
              allSuccess = false;
            }
          }

          // ۶. ضامن بیک کارڈ
          if (needsUpload(data['guarantorCnicBack'])) {
            debugPrint('📤 کلاؤڈینیری: ضامن بیک کارڈ جا رہا ہے...');
            final url = await CloudinaryUploadService.uploadFile(data['guarantorCnicBack'], isAudio: false);
            if (url != null) {
              data['guarantorCnicBack'] = url;
            } else {
              allSuccess = false;
            }
          }

          // صرف تب ریڈی کریں جب تمام فائلیں کلاؤڈینیری پر چڑھ چکی ہوں
          if (allSuccess) {
            data['status'] = 'ready_to_push';
            data['isSynced'] = false; // پش سروس کے لیے تالا کھولیں
            // updatedAt کو مکمل ختم کر دیا، صرف پہلے کا createdAt رہے گا
            await box.put(key, data);
            debugPrint('✅ تمام میڈیا کلاؤڈینیری پر چڑھ گیا، اب فائر اسٹور کے لیے ریڈی ہے!');
          } else {
            debugPrint('❌ کچھ فائلیں اپلوڈ نہیں ہو سکیں، اسٹیٹس پینڈنگ ہی رہے گا');
          }
        }
      }
    }
  }
}