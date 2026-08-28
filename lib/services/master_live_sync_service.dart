import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MasterLiveSyncService {
  static final MasterLiveSyncService _instance = MasterLiveSyncService._internal();
  factory MasterLiveSyncService() => _instance;
  MasterLiveSyncService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<StreamSubscription> _subscriptions = [];

  // 🎯 فائر اسٹور اور ہائیو کے عین مطابق نام (تصویر کے مطابق)
  final Map<String, String> _boxToCollectionMap = {
    'usersBox': 'usersBox',
    'customerBox': 'customerBox',
    'guarantorBox': 'guarantorBox',
    'transactionBox': 'transactionBox',
    'bankBox': 'bankBox',
    'expenseBox': 'expenseBox',
    'packageBox': 'packageBox',
    'stockBox': 'stockBox',
  };

  /// 🎯 بیک گراؤنڈ سنک شروع کرنے کا مرکزی میتھڈ
  void startMasterLiveSync() {
    stopMasterLiveSync();

    debugPrint('🔄 [MasterSync] فائر اسٹور سے ہائیو لائیو سنک شروع ہو رہا ہے...');

    _boxToCollectionMap.forEach((hiveBoxName, firestoreCollectionName) {
      _syncCollectionToHive(hiveBoxName, firestoreCollectionName);
    });
  }

  void _syncCollectionToHive(String boxName, String collectionName) {
    try {
      final box = Hive.box(boxName);

      final subscription = _firestore.collection(collectionName).snapshots().listen(
        (snapshot) {
          for (var change in snapshot.docChanges) {
            final docId = change.doc.id;
            final data = change.doc.data();

            if (change.type == DocumentChangeType.added || change.type == DocumentChangeType.modified) {
              if (data != null) {
                data['docId'] = docId;
                box.put(docId, data);
              }
            } else if (change.type == DocumentChangeType.removed) {
              box.delete(docId);
            }
          }
          debugPrint('⚡ [MasterSync] $boxName سائنک ہو گیا ($collectionName سے)');
        },
        onError: (error) {
          debugPrint('❌ [MasterSync Error] $collectionName سائنک کرنے میں مسئلہ: $error');
        },
      );

      _subscriptions.add(subscription);
    } catch (e) {
      debugPrint('❌ [MasterSync Error] $boxName کھولنے یا سائنک کرنے میں ایرر: $e');
    }
  }

  void stopMasterLiveSync() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }
}