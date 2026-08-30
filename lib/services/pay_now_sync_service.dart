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

      // 2. 🎯 [الٹرا لائٹ پے لوڈ] تمام اضافی اور ڈپلیکیٹ فیلڈز ختم کر دی گئی ہیں
      final Map<String, dynamic> payload = {
        'type': 'received',
        'customerId': cleanPhone,       // 👈 کسٹمر کی واحد شناختی کی
        'amount': enteredAmount,
        'discount': {
          'category': discountCategory,
          'value': discountValue,        // 👈 صرف اصل ویلیو رکھی گئی ہے
          'isPercentage': isDiscountPercentage,
        },
        'netReceived': netPayableAmount,
        'source': selectedPaymentSource,
        'splitPayments': splitPaymentsList,
        'description': description,
        'picturePath': attachmentPath ?? '',
        'audioPath': audioPath ?? 'Not Recorded',
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'pending',            // 👈 فارم کا اسٹیٹس
        'isSynced': false,              // 👈 ماسٹر سنک انجن کے لیے فلیگ
      };

      // 3. transactionBox میں ریکارڈ سیو کرنا
      var box = Hive.isBoxOpen('transactionBox')
          ? Hive.box('transactionBox')
          : await Hive.openBox('transactionBox');
      await box.add(payload);

      // 4. outboxBox میں سنک کیو (Queue) شامل کرنا
      if (Hive.isBoxOpen('outboxBox')) {
        var outbox = Hive.box('outboxBox');
        await outbox.add({
          'action': 'CREATE_TRANSACTION',
          'data': payload,
          'createdAt': DateTime.now().toIso8601String(),
        });
      }

      developer.log(
        "Clean payload stored successfully with isSynced=false for ID: $cleanPhone",
        name: "SyncService",
      );
      return true;
    } catch (e) {
      developer.log("SyncService Error", error: e, name: "SyncService");
      return false;
    }
  }
}