import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'dart:developer' as developer;

class SyncService {
  static Future<bool> processAndUploadTransaction({
    required String customerMobileNumber,
    required double enteredAmount,
    required double netPayableAmount,
    required String selectedPaymentSource,
    required String discountCategory,
    required double discountValue,
    required bool isDiscountPercentage,
    required double calculatedDiscountAmount,
    required List<Map<String, dynamic>> splitPaymentsList,
    required String description,
    required String? attachmentPath,
    required String? audioPath,
  }) async {
    try {
      String cleanPhone = customerMobileNumber.trim().replaceAll(RegExp(r'[^0-9]'), '');
      final String currentIsoDate = DateTime.now().toIso8601String();

      // 🎯 20 کریکٹرز کی آف لائن فائرسٹور یونیک آئی ڈی
      final String uniqueDocId = FirebaseFirestore.instance.collection('transactions').doc().id;

      // ۱۔ ٹرانزیکشن کا اصل پی لوڈ
      final Map<String, dynamic> payload = {
        'docId': uniqueDocId,
        'customerId': cleanPhone,
        'txAmount': enteredAmount,
        'txColor': 'green',
        'type': 'received',
        'status': 'pending',
        'isSynced': false,
        'createdAt': currentIsoDate,
        'discount': {
          'category': discountCategory,
          'value': discountValue,
          'isPercentage': isDiscountPercentage,
          'calculatedAmount': calculatedDiscountAmount,
        },
        'netReceived': netPayableAmount,
        'source': selectedPaymentSource,
        'splitPayments': splitPaymentsList,
        'description': description,
      };

      var box = Hive.isBoxOpen('transactionBox')
          ? Hive.box('transactionBox')
          : await Hive.openBox('transactionBox');
      await box.put(uniqueDocId, payload);

      if (Hive.isBoxOpen('outboxBox')) {
        var outbox = Hive.box('outboxBox');
        await outbox.put(uniqueDocId, {
          'action': 'CREATE_TRANSACTION',
          'data': payload,
          'createdAt': currentIsoDate,
        });
      }

      // 🎯 ۲۔ میڈیا چیک: اگر تصویر یا آڈیو موجود ہے صرف تب mediaBox میں اینٹری بنے گی
      bool hasPicture = attachmentPath != null && attachmentPath.isNotEmpty;
      bool hasAudio = audioPath != null && audioPath.isNotEmpty && audioPath != 'Not Recorded';

      if (hasPicture || hasAudio) {
        var mediaBox = Hive.isBoxOpen('mediaBox')
            ? Hive.box('mediaBox')
            : await Hive.openBox('mediaBox');

        String paynowMediaDocKey = "${cleanPhone}_paynow_$uniqueDocId";

        final Map<String, dynamic> paynowMediaMap = {
          'docId': paynowMediaDocKey,
          'customerId': cleanPhone,
          'txDocId': uniqueDocId,
          'sourcePage': 'paynow',
          'category': 'payment_media',
          'pictureData': hasPicture ? attachmentPath : 'NO_IMAGE',
          'audioData': hasAudio ? audioPath : 'NO_AUDIO_RECORDED',
          'mediaStatus': 'PENDING_UPLOAD',
          'isSynced': true, // PendingMediaService اسے اپ لوڈ کر کے URL ڈالے گی اور isSynced: false کرے گی
          'createdAt': currentIsoDate,
        };

        await mediaBox.put(paynowMediaDocKey, paynowMediaMap);
        developer.log("Success: Stored paynow media with key $paynowMediaDocKey", name: "SyncService");
      } else {
        developer.log("No media present. Skipped creating mediaBox entry.", name: "SyncService");
      }

      return true;
    } catch (e) {
      developer.log("SyncService Error", error: e, name: "SyncService");
      return false;
    }
  }
}