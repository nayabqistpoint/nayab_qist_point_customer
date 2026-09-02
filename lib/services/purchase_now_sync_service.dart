import 'package:cloud_firestore/cloud_firestore.dart';
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
          String existingStatus = (existingRecord['status'] ?? 'pending').toString().trim().toLowerCase();

          if (existingStatus == 'completed') {
            onError("محترم صارف! اس موبائل نمبر پر آپ کا ایک فعال قسطوں کا اکاؤنٹ پہلے سے موجود ہے۔ براہ کرم دوسرا موبائل نمبر استعمال کریں!");
            return false;
          }
        }
      }

      // 4. 🎯 [پہلا پے لوڈ] packageBox کے لیے (غیر ضروری فیلڈز سے پاک، صاف ستھرا پے لوڈ)
      final String currentIsoDate = DateTime.now().toIso8601String();
      
      // rawPackageData میں سے اگر پرانی فیلڈز آ رہی ہوں تو ان کی صفائی
      final Map<String, dynamic> cleanPackageData = Map<String, dynamic>.from(rawPackageData)
        ..remove('isPurchaseRequested')
        ..remove('customerPhone')
        ..remove('docId')
        ..remove('timestamp');

      final Map<String, dynamic> finalPackagePayload = {
        'customerId': cleanPhone,       // 👈 صرف اور صرف کسٹمر کی شناختی آئی ڈی (فون نمبر)
        ...cleanPackageData,            // 👈 کیلکولیٹر کا خالص ڈیٹا (mobileName, packageName, totalPrice, advanceAmount, monthlyInstallment وغیرہ)
        'status': 'pending',            // 👈 درخواست کا اسٹیٹس
        'isSynced': false,              // 👈 ماسٹر سنک کے لیے فلیگ
        'createdAt': currentIsoDate,    // 🎯 واحد اور یکساں ISO تاریخ
      };

      // فون نمبر کی Key پر packageBox میں سیو کرنا
      await packageBox.put(cleanPhone, finalPackagePayload);

      // 5. 🎯 [دوسرا پے لوڈ] transactionBox کے لیے (آپ کا اصل پے لوڈ - بالکل نبا چھڑا ہوا)
      Box transactionBox;
      if (Hive.isBoxOpen('transactionBox')) {
        transactionBox = Hive.box('transactionBox');
      } else {
        transactionBox = await Hive.openBox('transactionBox');
      }

      // 🎯 آف لائن ۲۰ کریکٹرز کی منفرد (Unique String) آئی ڈی بنانا
      final String uniqueDocId = FirebaseFirestore.instance.collection('transactions').doc().id;

      // رقم نکالنا (طے شدہ اصول کے مطابق)
      final double totalAmt = double.tryParse((rawPackageData['totalPrice'] ?? rawPackageData['price'] ?? rawPackageData['totalAmount'] ?? 0.0).toString()) ?? 0.0;

      final Map<String, dynamic> transactionPayload = {
        'docId': uniqueDocId,                                                       // 👈 یونیک ڈاکومنٹ آئی ڈی
        'customerId': cleanPhone,                                                  // 👈 کسٹمر کا موبائل نمبر
        'txAmount': totalAmt,                                                       // 👈 مطلوبہ رقم (صرف یہی رہے گی)
        'txColor': 'red',                                                           // 👈 پرچیز/سیل کے لیے سرخ رنگ
        'type': 'sale',                                                             // 👈 ٹائپ وہی (sale)
        'status': 'pending',                                                        // 👈 پینڈنگ اسٹیٹس
        'isSynced': false,                                                          // 👈 سنک فلیگ
        'createdAt': currentIsoDate,                                                // 🎯 بالکل وہی یکساں ISO تاریخ
        'mobileName': rawPackageData['mobileName'] ?? rawPackageData['deviceName'] ?? rawPackageData['title'] ?? 'N/A',
      };

      // 🎯 transactionBox میں یونیک کی (uniqueDocId) پر سیو کرنا
      await transactionBox.put(uniqueDocId, transactionPayload);

      developer.log(
        'Success: Saved to packageBox for Key: $cleanPhone and transactionBox for Key: $uniqueDocId', 
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