import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../hive_services/hive_box_manager.dart';

class UsersPullService {
  static const String collectionName = HiveBoxManager.usersBoxName;
  static StreamSubscription? _subscription;

  static void startLiveSync(String phone) {
    if (phone.isEmpty) return;
    stopLiveSync();

    _subscription = FirebaseFirestore.instance
        .collection(collectionName)
        .doc(phone)
        .snapshots()
        .listen((doc) async {
      // 🛡️ آف لائن شیلڈ
      if (doc.metadata.isFromCache) return;

      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.usersBoxName);

      if (doc.exists && doc.data() != null) {
        final data = Map<String, dynamic>.from(doc.data()!);
        data['isSynced'] = true;

        // 🎯 باکس کو پرانے یوزرز سے صاف کر کے صرف موجودہ صارف کا ریکارڈ رکھنا
        await box.clear();
        await box.put(phone, data);
        debugPrint('⚡ [usersBox] لائیو یوزر اپڈیٹ برائے: $phone');
      } else if (!doc.exists) {
        await box.delete(phone);
      }
    }, onError: (e) => debugPrint('❌ Users Live Error: $e'));
  }

  static void stopLiveSync() {
    _subscription?.cancel();
    _subscription = null;
  }
}