import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../hive_services/hive_box_manager.dart';

class AppConfigPullService {
  static const String collectionName = HiveBoxManager.appConfigBoxName;
  static StreamSubscription? _subscription;

  /// ⚡ لائیو ریل ٹائم لسنر مع مرر ڈیلیٹ
  static void startLiveSync() {
    _subscription?.cancel();

    _subscription = FirebaseFirestore.instance
        .collection(collectionName)
        .snapshots()
        .listen((snapshot) async {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.appConfigBoxName);
      final Set<String> cloudIds = {};

      // ۱. نیا یا تبدیل شدہ کنفگ ڈیٹا محفوظ کرنا
      for (var doc in snapshot.docs) {
        cloudIds.add(doc.id);
        final data = _sanitizeData(doc.data());
        data['isSynced'] = true;
        await box.put(doc.id, data);
      }

      // ۲. مرر ڈیلیٹ: اگر فائر اسٹور سے کٹا ہے تو ہائیو سے بھی ہٹاؤ
      for (var key in box.keys) {
        if (!cloudIds.contains(key.toString())) {
          final local = box.get(key);
          if (local is Map && local['isSynced'] == true) {
            await box.delete(key);
            debugPrint('🗑️ [appConfigBox] مرر ڈیلیٹ: $key');
          }
        }
      }
      debugPrint('⚡ [appConfigBox] لائیو اپڈیٹ: ${cloudIds.length} دستاویزات');
    }, onError: (e) => debugPrint('❌ AppConfig Live Error: $e'));
  }

  static void stopLiveSync() {
    _subscription?.cancel();
    _subscription = null;
  }

  static Map<String, dynamic> _sanitizeData(Map<String, dynamic> raw) {
    final Map<String, dynamic> clean = {};
    raw.forEach((key, value) {
      if (value is Timestamp) {
        clean[key] = value.toDate().toIso8601String();
      } else if (value is Map) {
        clean[key] = _sanitizeData(Map<String, dynamic>.from(value));
      } else if (value is List) {
        clean[key] = value.map((item) {
          if (item is Timestamp) return item.toDate().toIso8601String();
          if (item is Map) return _sanitizeData(Map<String, dynamic>.from(item));
          return item;
        }).toList();
      } else {
        clean[key] = value;
      }
    });
    return clean;
  }
}