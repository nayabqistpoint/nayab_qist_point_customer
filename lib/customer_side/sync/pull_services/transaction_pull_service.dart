import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../hive_services/hive_box_manager.dart';

class TransactionPullService {
  static const String collectionName = HiveBoxManager.transactionBoxName;
  static StreamSubscription? _subscription;

  static void startLiveSync(String phone) {
    _subscription?.cancel();

    _subscription = FirebaseFirestore.instance
        .collection(collectionName)
        .where('customerPhone', isEqualTo: phone)
        .snapshots()
        .listen((snapshot) async {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.transactionBoxName);

      final Set<String> cloudIds = {};
      for (var doc in snapshot.docs) {
        cloudIds.add(doc.id);
        final data = Map<String, dynamic>.from(doc.data());
        data['isSynced'] = true;
        await box.put(doc.id, data);
      }

      // 🛡️ آف لائن شیلڈ
      if (snapshot.metadata.isFromCache) return;

      for (var key in box.keys) {
        if (!cloudIds.contains(key.toString())) {
          final local = box.get(key);
          if (local is Map && local['isSynced'] == true) {
            await box.delete(key);
            debugPrint('🗑️ [transactionBox] مرر ڈیلیٹ: $key');
          }
        }
      }
    }, onError: (e) => debugPrint('❌ Transaction Live Error: $e'));
  }

  static void stopLiveSync() {
    _subscription?.cancel();
    _subscription = null;
  }
}