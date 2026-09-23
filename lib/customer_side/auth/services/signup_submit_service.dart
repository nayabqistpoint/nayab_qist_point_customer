import 'package:flutter/material.dart';
import '../../hive_services/hive_box_manager.dart';
import '../../inspector/submission_receipt_sheet_ui.dart';
import '../../payload_services/signup_payload_service.dart';
import '../../sync/media_sync/pending_media_sync_service.dart';

class SignupSubmitService {
  static Future<void> process({
    required BuildContext context,
    required Map<String, dynamic> data,
    required VoidCallback onStart,
    required VoidCallback onEnd,
    required VoidCallback onSuccess,
  }) async {
    final error = SignupPayloadService.validate(data);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error, textDirection: TextDirection.rtl),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
      return;
    }

    final phone = (data['customerPhone'] ?? data['phone'] ?? '').toString().trim().replaceAll(RegExp(r'[^0-9]'), '');
    final allPayloads = SignupPayloadService.buildAllPayloads(data);

    SubmissionReceiptSheetUi.show(
      context,
      title: 'کسٹمر رجسٹریشن تصدیق',
      subtitle: 'تمام معلومات کی جانچ کے بعد کنفرم کریں',
      rawPayload: allPayloads,
      onConfirm: () async {
        onStart();
        await HiveBoxManager.openSessionBoxes();
        final isSaved = await HiveBoxManager.writeBatchPayloads(
          docId: phone,
          payloads: allPayloads,
          logTitle: 'کسٹمر رجسٹریشن مکمل',
        );

        if (isSaved) {
          final settingsBox = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
          await settingsBox.put('isLoggedIn', true);
          await settingsBox.put('activePhone', phone);

          // 🎯 بنیادی اصلاح: await لگائیں تاکہ کلاؤڈینیری اپلوڈ اور لنک جنریشن کا باقاعدہ انتظار ہو
          debugPrint('⏳ میڈیا کلاؤڈینیری پر اپلوڈ ہونا شروع ہو رہا ہے...');
          await PendingMediaSyncService.processPendingUploads();
          debugPrint('🏁 کلاؤڈینیری پروسیس مکمل، اب اگلے صفحے پر جا رہے ہیں');

          onEnd();
          onSuccess();
        } else {
          onEnd();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('رجسٹریشن محفوظ کرنے میں خرابی ہوئی!')),
            );
          }
        }
      },
    );
  }
}