import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SyncService {
  /// 🎯 پے نو پے لوڈ کو ہائیو، آؤٹ باکس یا فائر اسٹور پر ڈسٹریبیوٹ کرنے والی سروس
  static Future<bool> processAndUploadTransaction(Map<String, dynamic> payload) async {
    try {
      // ۱۔ لوکل ہائیو ٹرانزیکشن باکس میں سیو کرنا
      if (Hive.isBoxOpen('transactionBox')) {
        var box = Hive.box('transactionBox');
        await box.add(payload);
      } else {
        var box = await Hive.openBox('transactionBox');
        await box.add(payload);
      }

      // ۲۔ آؤٹ باکس یا سنک کیو (Sync Queue) میں بھیجنا تاکہ ایڈمن کو اپلوڈ ہو سکے
      if (Hive.isBoxOpen('outboxBox')) {
        var outbox = Hive.box('outboxBox');
        await outbox.add({
          'action': 'CREATE_TRANSACTION',
          'data': payload,
          'createdAt': DateTime.now().toIso8601String(),
        });
      }

      debugPrint("Payload successfully delivered to SyncService!");
      return true;
    } catch (e) {
      debugPrint("SyncService Error: $e");
      return false;
    }
  }
}