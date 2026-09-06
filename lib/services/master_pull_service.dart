import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'master_push_sync_service.dart';

class MasterLiveSyncService {
  static final MasterLiveSyncService _instance = MasterLiveSyncService._internal();
  factory MasterLiveSyncService() => _instance;
  MasterLiveSyncService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<StreamSubscription> _firestoreSubscriptions = [];

  /// 🟢 ۱۔ main.dart میں آن ہوتے ہی گلوبل باکسز (appConfig, stock, users) کا لائیو سنک شروع کرنا
  Future<void> initPullService() async {
    await _ensureGlobalBoxesOpened();
    _startGlobalLiveSync();
  }

  /// 🎯 گلوبل باکسز - (StockBox اور UsersBox اب آف لائن پر ڈیلیٹ نہیں ہوں گے)
  void _startGlobalLiveSync() {
    List<String> globalBoxes = ['appConfigBox', 'stockBox', 'usersBox'];

    for (String boxName in globalBoxes) {
      if (!Hive.isBoxOpen(boxName)) continue;
      final hiveBox = Hive.box(boxName);

      final sub = _firestore.collection(boxName).snapshots().listen((snap) async {
        await _processSnapshot(
          onProcess: () async {
            // 🛑 اہم سیکیورٹی: اگر نیٹ ورک بند ہے یا میٹا ڈیٹا آف لائن ہے تو لوکل ہائیو کا ڈیٹا ڈیلیٹ نہ کریں!
            if (snap.metadata.isFromCache) {
              debugPrint('🌐 [$boxName] کیشے ڈیٹا سے پڑھا جا رہا ہے، لوکل ڈسک محفوظ رہے گی۔');
            }

            for (var doc in snap.docs) {
              if (doc.exists) {
                final preparedData = _prepareData(doc.id, doc.data());
                // آٹو جنریٹڈ یا فون نمبر والی تمام ڈاکومنٹ آئی ڈیز لوکل ہائیو میں سیو ہوں گی
                await hiveBox.put(doc.id, preparedData);
              }
            }
          },
          errorTag: '$boxName Global Pull',
        );
      });
      _firestoreSubscriptions.add(sub);
    }
    debugPrint('🌐 [MasterPull] گلوبل باکسز (appConfig, stock, users) کا محفوظ سنک ایکٹیو ہو گیا۔');
  }

  /// 🟢 ۲۔ لاگ ان ہونے کے بعد ٹارگٹڈ کسٹمر باکسز کا لائیو سنک شروع کرنا
  Future<void> startMasterLiveSync(String activePhone) async {
    final cleanPhone = activePhone.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.isEmpty) return;

    await _ensureTargetedBoxesOpened();

    List<String> targetedBoxes = [
      'customerBox',
      'guarantorBox',
      'packageBox',
      'transactionBox',
      'mediaBox'
    ];

    for (String boxName in targetedBoxes) {
      if (!Hive.isBoxOpen(boxName)) continue;
      final hiveBox = Hive.box(boxName);

      if (boxName == 'transactionBox' || boxName == 'mediaBox') {
        final sub = _firestore
            .collection(boxName)
            .where('customerId', isEqualTo: cleanPhone)
            .snapshots()
            .listen((snap) async {
          await _processSnapshot(
            onProcess: () async {
              for (var doc in snap.docs) {
                if (doc.exists) {
                  final preparedData = _prepareData(doc.id, doc.data());
                  await hiveBox.put(doc.id, preparedData);
                }
              }
            },
            errorTag: '$boxName Pull',
          );
        });
        _firestoreSubscriptions.add(sub);
      } else {
        final sub = _firestore.collection(boxName).doc(cleanPhone).snapshots().listen((docSnap) async {
          await _processSnapshot(
            onProcess: () async {
              final data = docSnap.data();
              // 🛑 صرف اس وقت لوکل سیو کریں جب ڈیٹا موجود ہو، آف لائن پر delete() ہرگز نہ کریں!
              if (docSnap.exists && data != null) {
                final preparedData = _prepareData(docSnap.id, data);
                await hiveBox.put(cleanPhone, preparedData);
              }
            },
            errorTag: '$boxName Pull',
          );
        });
        _firestoreSubscriptions.add(sub);
      }
    }
    debugPrint('🔥 [MasterPull] ٹارگٹڈ کسٹمر باکسز کا لائیو لسنر ایکٹیو ہو گیا۔');
  }

  Future<void> _processSnapshot({required Future<void> Function() onProcess, required String errorTag}) async {
    if (MasterPushSyncService().isPushing) return;
    MasterPushSyncService().isPullingActive = true;

    try {
      await onProcess();
    } catch (e) {
      debugPrint('❌ [$errorTag Error]: $e');
    } finally {
      MasterPushSyncService().isPullingActive = false;
    }
  }

  Map<String, dynamic> _prepareData(String docId, Map<String, dynamic> raw) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(raw);
    data['docId'] = data['docId'] ?? docId;

    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
    } else if (data['createdAt'] == null) {
      data['createdAt'] = DateTime.now().toIso8601String();
    }

    if (data['timestamp'] is Timestamp) {
      data['timestamp'] = (data['timestamp'] as Timestamp).toDate().toIso8601String();
    }

    final Map<String, dynamic> orderedMap = {};
    data.forEach((key, value) {
      if (key != 'status' && key != 'isSynced' && key != 'timestamp') {
        orderedMap[key] = value;
      }
    });

    orderedMap['status'] = data['status'] ?? 'approved';
    orderedMap['isSynced'] = data['isSynced'] ?? true;
    if (data.containsKey('timestamp')) orderedMap['timestamp'] = data['timestamp'];

    return orderedMap;
  }

  Future<void> stopLiveSync() async {
    for (var sub in _firestoreSubscriptions) {
      await sub.cancel();
    }
    _firestoreSubscriptions.clear();
  }

  Future<void> _ensureGlobalBoxesOpened() async {
    List<String> globals = ['appConfigBox', 'stockBox', 'usersBox', 'settingsBox'];
    for (final name in globals) {
      if (!Hive.isBoxOpen(name)) await Hive.openBox(name);
    }
  }

  Future<void> _ensureTargetedBoxesOpened() async {
    List<String> targeted = ['customerBox', 'guarantorBox', 'packageBox', 'transactionBox', 'mediaBox'];
    for (final name in targeted) {
      if (!Hive.isBoxOpen(name)) await Hive.openBox(name);
    }
  }
}