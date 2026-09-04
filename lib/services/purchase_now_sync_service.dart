import 'package:hive/hive.dart';
import 'dart:developer' as developer;

class PurchaseNowSyncService {
  static Future<bool> processAndSavePurchaseRequest({
    required String customerMobileNumber,
    required Map<String, dynamic> rawPackageData,
    required Function(String error) onError,
  }) async {
    try {
      String cleanPhone = customerMobileNumber.trim().replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanPhone.isEmpty) {
        onError("خامی: کسٹمر کا موبائل نمبر غائب ہے!");
        return false;
      }

      if (rawPackageData.isEmpty) {
        onError("براہ کرم پہلے قسط کیلکولیٹر سے پیکج کا انتخاب کریں!");
        return false;
      }

      Box packageBox = Hive.isBoxOpen('packageBox') 
          ? Hive.box('packageBox') 
          : await Hive.openBox('packageBox');

      if (packageBox.containsKey(cleanPhone)) {
        final existingRecord = packageBox.get(cleanPhone);
        if (existingRecord is Map) {
          String existingStatus = (existingRecord['status'] ?? 'pending').toString().trim().toLowerCase();
          if (existingStatus == 'completed') {
            onError("محترم صارف! اس موبائل نمبر پر آپ کا ایک فعال قسطوں کا اکاؤنٹ پہلے سے موجود ہے۔");
            return false;
          }
        }
      }

      final String currentIsoDate = DateTime.now().toIso8601String();

      final Map<String, dynamic> cleanPackageData = Map<String, dynamic>.from(rawPackageData);
      String? audioNoteData = cleanPackageData.remove('audioPath');
      cleanPackageData.remove('hasAudioRecorded');
      cleanPackageData.remove('isPurchaseRequested');
      cleanPackageData.remove('customerPhone');
      cleanPackageData.remove('docId');
      cleanPackageData.remove('timestamp');

      final Map<String, dynamic> finalPackagePayload = {
        'customerId': cleanPhone,
        ...cleanPackageData,
        'status': 'pending',
        'isSynced': false,
        'createdAt': currentIsoDate,
      };

      // 🎯 packageBox: Key = cleanPhone
      await packageBox.put(cleanPhone, finalPackagePayload);

      // 🎯 transactionBox: Key = cleanPhone_purchase (منفرد کی)
      Box transactionBox = Hive.isBoxOpen('transactionBox') 
          ? Hive.box('transactionBox') 
          : await Hive.openBox('transactionBox');

      final double totalAmt = double.tryParse((rawPackageData['totalPrice'] ?? rawPackageData['price'] ?? rawPackageData['totalAmount'] ?? 0.0).toString()) ?? 0.0;

      String purchaseTxDocId = "${cleanPhone}_purchase";

      final Map<String, dynamic> transactionPayload = {
        'docId': purchaseTxDocId,
        'customerId': cleanPhone,
        'txAmount': totalAmt,
        'txColor': 'red',
        'type': 'sale',
        'status': 'pending',
        'isSynced': false,
        'createdAt': currentIsoDate,
        'mobileName': rawPackageData['mobileName'] ?? rawPackageData['deviceName'] ?? rawPackageData['title'] ?? 'N/A',
      };

      await transactionBox.put(purchaseTxDocId, transactionPayload);

      // 🎯 mediaBox: Key = cleanPhone_purchase (مربوط اور منفرد کی)
      Box mediaBox = Hive.isBoxOpen('mediaBox') 
          ? Hive.box('mediaBox') 
          : await Hive.openBox('mediaBox');

      String purchaseMediaDocKey = "${cleanPhone}_purchase";

      final Map<String, dynamic> purchaseMediaMap = {
        'customerId': cleanPhone,
        'txDocId': purchaseTxDocId,
        'sourcePage': 'purchase',
        'category': 'purchase_media',
        'audioData': (audioNoteData != null && audioNoteData.isNotEmpty) ? audioNoteData : 'NO_AUDIO_RECORDED',
        'mediaStatus': (audioNoteData != null && audioNoteData.isNotEmpty) ? 'PENDING_UPLOAD' : 'NO_MEDIA',
        'isSynced': true,
        'createdAt': currentIsoDate,
      };

      await mediaBox.put(purchaseMediaDocKey, purchaseMediaMap);

      developer.log("Success: Saved purchase media with key $purchaseMediaDocKey", name: "PurchaseNowSyncService");
      return true;
    } catch (e) {
      developer.log('Error in PurchaseNowSyncService', error: e, name: 'PurchaseNowSyncService');
      onError("خرابی پیش آئی: ${e.toString()}");
      return false;
    }
  }
}