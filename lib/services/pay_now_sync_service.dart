import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'dart:developer' as developer;

class SyncService {
  /// 🎯 پے لوڈ (Payload) کی تیاری اور ہائیو باکسز (transactionBox & outboxBox) میں سیونگ کی سروس
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
      // 1. کسٹمر نمبر سے غیر ضروری کریکٹرز کی صفائی
      String cleanPhone = customerMobileNumber.trim().replaceAll(RegExp(r'[^0-9]'), '');

      // 2. 🎯 آف لائن ہی 20 کریکٹرز کی منفرد String Doc ID جنریٹ کرنا (بغیر آن لائن نیٹ ورک کال کے)
      final String uniqueDocId = FirebaseFirestore.instance.collection('transactions').doc().id;

      // 3. 🎯 نیا اور سٹینڈرڈ پے لوڈ (تمام پرانے فیلڈز محفوظ + نئے فیلڈز شامل)
      final Map<String, dynamic> payload = {
        'docId': uniqueDocId,                 // 👈 یونیک ڈاکومنٹ آئی ڈی
        'customerId': cleanPhone,            // 👈 کسٹمر کی واحد شناختی کی
        'txAmount': enteredAmount,           // 👈 سٹینڈرڈ رقم (amount کی جگہ)
        'txColor': 'green',                  // 👈 پے ناؤ / وصولی کے لیے ہمیشہ سبز
        'type': 'received',                  // 👈 ٹائپ ریسیوڈ ہی رہے گی
        'status': 'pending',                 // 👈 فارم کا اسٹیٹس
        'isSynced': false,                   // 👈 ماسٹر سنک انجن کے لیے فلیگ
        'createdAt': DateTime.now().toIso8601String(), // 👈 یکساں ٹائم سٹیمپ فیلڈ

        // 🎯 آپ کے تمام پرانے اور اہم فیلڈز (100% محفوظ)
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
        'picturePath': attachmentPath ?? '',
        'audioPath': audioPath ?? 'Not Recorded',
      };

      // 4. transactionBox میں یونیک سٹرنگ Key کے ساتھ ریکارڈ سیو کرنا (box.add کی جگہ box.put)
      var box = Hive.isBoxOpen('transactionBox')
          ? Hive.box('transactionBox')
          : await Hive.openBox('transactionBox');
      await box.put(uniqueDocId, payload);

      // 5. outboxBox میں سنک کیو (Queue) شامل کرنا
      if (Hive.isBoxOpen('outboxBox')) {
        var outbox = Hive.box('outboxBox');
        await outbox.put(uniqueDocId, {
          'action': 'CREATE_TRANSACTION',
          'data': payload,
          'createdAt': DateTime.now().toIso8601String(),
        });
      }

      developer.log(
        "Clean payload stored successfully with docId: $uniqueDocId for Phone: $cleanPhone",
        name: "SyncService",
      );
      return true;
    } catch (e) {
      developer.log("SyncService Error", error: e, name: "SyncService");
      return false;
    }
  }
}