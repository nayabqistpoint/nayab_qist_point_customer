import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../hive_services/hive_box_manager.dart';

class CustomerPullService {
  static StreamSubscription<DocumentSnapshot>? _liveSubscription;

  /// 🎯 MasterSyncHub کے لیے ریئل ٹائم لائیو لسنر
  static void startLiveSync(String phone) {
    if (phone.isEmpty) return;

    // اگر پہلے سے کوئی لسنر چل رہا ہو تو بند کریں
    stopLiveSync();

    try {
      _liveSubscription = FirebaseFirestore.instance
          .collection(HiveBoxManager.customerBoxName)
          .doc(phone)
          .snapshots()
          .listen((snapshot) async {
        if (snapshot.exists && snapshot.data() != null) {
          final data = Map<String, dynamic>.from(snapshot.data()!);
          data['isSynced'] = true;

          final box = await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);
          
          // صرف فعال کسٹمر کا ڈیٹا رکھنا
          await box.clear();
          await box.put(phone, data);
          debugPrint('✅ Customer Live Sync Updated for: $phone');
        }
      }, onError: (error) {
        debugPrint('❌ Customer Live Sync Error: $error');
      });
    } catch (e) {
      debugPrint('❌ Customer startLiveSync Error: $e');
    }
  }

  /// 🛑 سیشن کے اختتام یا لاگ آؤٹ پر لسنر بند کرنا
  static void stopLiveSync() {
    _liveSubscription?.cancel();
    _liveSubscription = null;
  }
}