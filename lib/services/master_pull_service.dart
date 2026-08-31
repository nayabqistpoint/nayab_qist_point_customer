import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MasterLiveSyncService {
  static final MasterLiveSyncService _instance = MasterLiveSyncService._internal();
  factory MasterLiveSyncService() => _instance;
  MasterLiveSyncService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const List<String> _targetBoxes = [
    'customerBox',
    'guarantorBox',
    'packageBox',
    'usersBox',
    'transactionBox',
    'stockBox',
  ];

  /// main.dart کے لیے ابتدائی تیاری
  Future<void> initPullService() async {
    await _ensureBoxesOpened();
  }

  /// کسٹمر لاگ ان پر بیک گراؤنڈ سنک (UI کو بلاک کیے بغیر)
  Future<void> onUserLoggedIn(String activePhone) async {
    final cleanPhone = activePhone.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.isEmpty) return;

    await _ensureBoxesOpened();

    // 🚀 بیک گراؤنڈ میں سنک فائر کریں تاکہ بٹن پر لوڈنگ نہ آئے
    Future.microtask(() => _pullFromFirestore(cleanPhone));
  }

  /// 🟢 فیلڈز کی درست ترتیب (Splay / Custom Key Reordering)
  Map<String, dynamic> _reorderFields(Map<String, dynamic> rawData) {
    final Map<String, dynamic> orderedMap = {};

    // 1️⃣ پہلے بزنس لاجک کی تمام عام فیلڈز شامل کریں
    rawData.forEach((key, value) {
      if (key != 'status' && key != 'isSynced' && key != 'timestamp') {
        orderedMap[key] = value;
      }
    });

    // 2️⃣ اسٹیٹس اور سنک فیلڈز کو ہمیشہ اخر میں رکھیں
    if (rawData.containsKey('status')) orderedMap['status'] = rawData['status'];
    orderedMap['isSynced'] = rawData['isSynced'] ?? true;
    if (rawData.containsKey('timestamp')) orderedMap['timestamp'] = rawData['timestamp'];

    return orderedMap;
  }

  Future<void> _pullFromFirestore(String cleanPhone) async {
    try {
      for (String boxName in _targetBoxes) {
        final hiveBox = Hive.box(boxName);

        // ۱۔ stockBox: مکمل اوپن کلیکشن
        if (boxName == 'stockBox') {
          final QuerySnapshot snap = await _firestore.collection(boxName).get();
          final Set<String> firestoreIds = snap.docs.map((doc) => doc.id.toString()).toSet();

          for (var doc in snap.docs) {
            if (doc.data() is Map) {
              final Map<String, dynamic> data = Map<String, dynamic>.from(doc.data() as Map);
              final orderedData = _reorderFields(data);
              await hiveBox.put(doc.id.toString(), orderedData);
            }
          }

          // 🎯 فائر سٹور سے ڈیلیٹ ہونے والے ڈیٹا کو ہائیو سے حذف کرنا
          final localKeys = hiveBox.keys.map((k) => k.toString()).toList();
          for (var localKey in localKeys) {
            if (!firestoreIds.contains(localKey)) {
              await hiveBox.delete(localKey);
            }
          }
        } 
        // ۲۔ transactionBox: customerId فیلڈ کے ساتھ
        else if (boxName == 'transactionBox') {
          final QuerySnapshot snap = await _firestore
              .collection(boxName)
              .where('customerId', isEqualTo: cleanPhone)
              .get();

          // فائر سٹور پر اس کسٹمر کی موجودہ تمام ڈاکومنٹ آئی ڈیز کا سیٹ
          final Set<String> firestoreDocIds = snap.docs.map((doc) => doc.id.toString()).toSet();

          // الف) فائر سٹور کا نیا ڈیٹا ہائیو میں ڈالنا (سٹرنگ کی کے ساتھ)
          for (var doc in snap.docs) {
            if (doc.data() is Map) {
              final Map<String, dynamic> data = Map<String, dynamic>.from(doc.data() as Map);
              final orderedData = _reorderFields(data);
              await hiveBox.put(doc.id.toString(), orderedData);
            }
          }

          // ب) 🎯 اہم ترین تبدیلی: اگر فائر سٹور سے ڈاکومنٹ ڈیلیٹ ہو گیا ہے یا پرانی انٹیجر کیز پڑی ہیں، انہیں ہائیو سے کاٹنا
          final localKeys = hiveBox.keys.toList();
          for (var key in localKeys) {
            final String stringKey = key.toString();
            final item = hiveBox.get(key);

            if (item is Map) {
              final p = (item['customerPhone'] ?? item['customerId'] ?? '').toString().trim();
              // اگر یہ اسی کسٹمر کی اینٹری ہے لیکن فائر سٹور پر اب موجود نہیں ہے، تو ہائیو سے کاٹ دیں
              if (p == cleanPhone && !firestoreDocIds.contains(stringKey)) {
                await hiveBox.delete(key);
              }
            }
          }
        } 
        // ۳۔ باقی تمام باکسز: Doc ID ہی customerId ہے
        else {
          final DocumentSnapshot docSnap = await _firestore.collection(boxName).doc(cleanPhone).get();
          if (docSnap.exists && docSnap.data() is Map) {
            final Map<String, dynamic> data = Map<String, dynamic>.from(docSnap.data() as Map);
            final orderedData = _reorderFields(data);
            await hiveBox.put(cleanPhone, orderedData);
          } else {
            // اگر فائر سٹور میں یہ ڈاکومنٹ ختم ہو چکا ہے تو لوکل ہائیو سے بھی ریموو کریں
            await hiveBox.delete(cleanPhone);
          }
        }
      }

      await Hive.box('settingsBox').put('lastSyncedTime', DateTime.now().toIso8601String());
      debugPrint('🎉 [MasterPull] ڈیٹا فائر سٹور کے مطابق ہائیو میں مکمل سنک اور ڈیلیٹ ہو گیا۔');

    } catch (e) {
      debugPrint('❌ [MasterPull Error]: $e');
    }
  }

  Future<void> _ensureBoxesOpened() async {
    for (final name in _targetBoxes) {
      if (!Hive.isBoxOpen(name)) await Hive.openBox(name);
    }
    if (!Hive.isBoxOpen('settingsBox')) await Hive.openBox('settingsBox');
  }

  void startMasterLiveSync() {}
}