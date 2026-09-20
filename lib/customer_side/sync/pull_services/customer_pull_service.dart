import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../hive_services/hive_box_manager.dart';

class CustomerPullService {
  static const String collectionName = HiveBoxManager.customerBoxName;
  static StreamSubscription? _subscription;

  static void startLiveSync(String phone) {
    _subscription?.cancel();

    _subscription = FirebaseFirestore.instance
        .collection(collectionName)
        .doc(phone)
        .snapshots()
        .listen((doc) async {
      // 🛡️ آف لائن شیلڈ: اگر ڈیٹا کلاؤڈ سرور سے تصدیق شدہ نہ ہو تو پرماننٹ ڈیٹا مت چھیڑو
      if (doc.metadata.isFromCache) return;

      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);

      if (doc.exists && doc.data() != null) {
        final data = Map<String, dynamic>.from(doc.data()!);
        data['isSynced'] = true;
        await box.put(phone, data);
        debugPrint('⚡ [customerBox] لائیو پروفائل اپڈیٹ');
      } else if (!doc.exists) {
        // صرف تب ڈیلیٹ کرو جب ایڈمن نے لائیو سرور سے واقعی ڈیلیٹ کیا ہو
        await box.delete(phone);
        debugPrint('🗑️ [customerBox] سرور سے تصدیق شدہ ڈیلیٹ ہوا');
      }
    }, onError: (e) => debugPrint('❌ Customer Live Error: $e'));
  }

  static void stopLiveSync() {
    _subscription?.cancel();
    _subscription = null;
  }
}