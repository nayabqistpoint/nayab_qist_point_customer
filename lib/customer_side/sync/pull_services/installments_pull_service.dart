import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../hive_services/hive_box_manager.dart';

class InstallmentsPullService {
  static const String collectionName = HiveBoxManager.installmentsBoxName;
  static StreamSubscription? _subscription;

  static void startLiveSync(String phone) {
    _subscription?.cancel();

    _subscription = FirebaseFirestore.instance
        .collection(collectionName)
        .where('customerPhone', isEqualTo: phone)
        .snapshots()
        .listen((snapshot) async {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.installmentsBoxName);

      // ۱. نیا ڈیٹا ہائیو میں لکھنا
      final Set<String> cloudIds = {};
      for (var doc in snapshot.docs) {
        cloudIds.add(doc.id);
        final data = Map<String, dynamic>.from(doc.data());
        data['isSynced'] = true;
        await box.put(doc.id, data);
      }

      // 🛡️ آف لائن شیلڈ: اگر کیشے سے ہے تو پرماننٹ لوکل ڈیٹا کبھی ڈیلیٹ نہ کرو
      if (snapshot.metadata.isFromCache) return;

      // ۲. مرر ڈیلیٹ صرف تصدیق شدہ سرور رسپانس پر
      for (var key in box.keys) {
        if (!cloudIds.contains(key.toString())) {
          final local = box.get(key);
          if (local is Map && local['isSynced'] == true) {
            await box.delete(key);
            debugPrint('🗑️ [installmentsBox] مرر ڈیلیٹ: $key');
          }
        }
      }
    }, onError: (e) => debugPrint('❌ Installments Live Error: $e'));
  }

  static void stopLiveSync() {
    _subscription?.cancel();
    _subscription = null;
  }
}