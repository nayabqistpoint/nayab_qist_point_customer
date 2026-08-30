import 'package:hive/hive.dart';
import 'dart:developer' as developer;

class PurchaseNowSyncService {
  /// 🎯 پے لوڈ (Payload) کی تیاری، اسٹیٹس وریفکیشن اور ہائیو میں سیونگ کی سروس
  static Future<bool> processAndSavePurchaseRequest({
    required String customerMobileNumber,
    required Map<String, dynamic> rawPackageData,
    required Function(String error) onError,
  }) async {
    try {
      // 1. نمبر میں سے صرف ہندسے نکالنا اور تصدیق کرنا
      String cleanPhone = customerMobileNumber.trim().replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanPhone.isEmpty) {
        onError("خامی: کسٹمر کا موبائل نمبر غائب ہے!");
        return false;
      }

      if (rawPackageData.isEmpty) {
        onError("براہ کرم پہلے قسط کیلکولیٹر سے پیکج کا انتخاب کریں!");
        return false;
      }

      // 2. packageBox کو کھولنا
      Box packageBox;
      if (Hive.isBoxOpen('packageBox')) {
        packageBox = Hive.box('packageBox');
      } else {
        packageBox = await Hive.openBox('packageBox');
      }

      // 3. پرانا اکاؤنٹ اسٹیٹس چیک کرنے کی لاجک
      if (packageBox.containsKey(cleanPhone)) {
        final existingRecord = packageBox.get(cleanPhone);

        if (existingRecord is Map) {
          String existingStatus = (existingRecord['status'] ?? 'Pending').toString().trim().toLowerCase();

          if (existingStatus == 'completed') {
            onError("محترم صارف! اس موبائل نمبر پر آپ کا ایک فعال قسطوں کا اکاؤنٹ پہلے سے موجود ہے۔ براہ کرم دوسرا موبائل نمبر استعمال کریں!");
            return false;
          }
        }
      }

      // 4. 🎯 [پہلا پے لوڈ] packageBox کے لیے
      final String currentTimestamp = DateTime.now().toString();
      final Map<String, dynamic> finalPackagePayload = {
        'customerId': cleanPhone,       // 👈 کسٹمر کا موبائل نمبر (شناختی کی)
        ...rawPackageData,              // 👈 پیکج کیلکولیٹر کا ڈیٹا
        'status': 'Pending',            // 👈 درخواست کا اسٹیٹس
        'isSynced': false,              // 👈 ماسٹر سنک کے لیے فلیگ
        'timestamp': currentTimestamp,
      };

      // فون نمبر کی Key پر packageBox میں سیو کرنا
      await packageBox.put(cleanPhone, finalPackagePayload);

      // 5. 🎯 [دوسرا پے لوڈ] transactionBox کے لیے پرفیکٹ اینٹری
      Box transactionBox;
      if (Hive.isBoxOpen('transactionBox')) {
        transactionBox = Hive.box('transactionBox');
      } else {
        transactionBox = await Hive.openBox('transactionBox');
      }

      final Map<String, dynamic> transactionPayload = {
        'type': 'sale',                 // 👈 ٹرانزیکشن کی ٹائپ (Sale)
        'customerId': cleanPhone,       // 👈 کسٹمر کی شناختی کی
        'mobileName': rawPackageData['mobileName'] ?? rawPackageData['deviceName'] ?? rawPackageData['title'] ?? 'N/A',
        'totalPrice': rawPackageData['totalPrice'] ?? rawPackageData['price'] ?? rawPackageData['totalAmount'] ?? 0.0,
        'status': 'pending',
        'isSynced': false,
        'createdAt': DateTime.now().toIso8601String(),
      };

      // transactionBox میں ایڈ کرنا
      await transactionBox.add(transactionPayload);

      developer.log(
        'Success: Saved to packageBox and transactionBox for Key: $cleanPhone', 
        name: 'PurchaseNowSyncService'
      );
      return true;
    } catch (e) {
      developer.log('Error in PurchaseNowSyncService', error: e, name: 'PurchaseNowSyncService');
      onError("خرابی پیش آئی: ${e.toString()}");
      return false;
    }
  }
}