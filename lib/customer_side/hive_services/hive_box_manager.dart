import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/inspector/inspector_store.dart';
import 'package:nayab_qist_point_customer/customer_side/sync/master_sync_hub.dart';

class HiveBoxManager {
  // ۱. پبلک گلوبل باکسز
  static const String settingsBoxName = 'settingsBox';
  static const String usersBoxName = 'usersBox';
  static const String stockBoxName = 'stockBox';
  static const String appConfigBoxName = 'appConfigBox';

  // ۲. یوزر سیشن باکسز
  static const String customerBoxName = 'customerBox';
  static const String guarantorBoxName = 'guarantorBox';
  static const String mediaBoxName = 'mediaBox';
  static const String installmentsBoxName = 'installmentsBox';
  static const String transactionBoxName = 'transactionBox';

  static Future<void> initGlobalBoxes() async {
    await Hive.initFlutter();
    await Future.wait([
      openSafeBox(settingsBoxName),
      openSafeBox(usersBoxName),
      openSafeBox(stockBoxName),
      openSafeBox(appConfigBoxName),
    ]);
  }

  static Future<void> openSessionBoxes() async {
    await Future.wait([
      openSafeBox(customerBoxName),
      openSafeBox(guarantorBoxName),
      openSafeBox(mediaBoxName),
      openSafeBox(installmentsBoxName),
      openSafeBox(transactionBoxName),
    ]);
  }

  static Future<void> closeSessionBoxes() async {
    await Future.wait([
      _closeSafeBox(customerBoxName),
      _closeSafeBox(guarantorBoxName),
      _closeSafeBox(mediaBoxName),
      _closeSafeBox(installmentsBoxName),
      _closeSafeBox(transactionBoxName),
    ]);
  }

  static Future<Box> openSafeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }
    return await Hive.openBox(boxName);
  }

  static Future<void> _closeSafeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  // ---------------------------------------------------------------------------
  // 🎯 یونیورسل لائیو لسنر گیٹ وے (تمام 9 باکسز کے لیے مستقل حل)
  // ---------------------------------------------------------------------------
  /// کسی بھی باکس کے لیے ValueListenable حاصل کرنے کا واحد گیٹ وے
  static ValueListenable<Box>? listenBox(String boxName) {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName).listenable();
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // 💾 یونیورسل ایٹامک بیچ رائٹ (تمام باکسز کے لیے خودکار سنک کے ساتھ)
  // ---------------------------------------------------------------------------
  static Future<bool> writeBatchPayloads({
    required String docId,
    required Map<String, Map<String, dynamic>> payloads,
    String logTitle = 'ڈیٹا لوکل محفوظ ہوا',
  }) async {
    try {
      for (final entry in payloads.entries) {
        final boxName = entry.key;
        final innerMap = entry.value;
        final box = await openSafeBox(boxName);

        // اگر پروفائل باکس ہے تو پرانا ڈیٹا ہٹا کر صرف سنگل یوزر رکھنا
        if (boxName == customerBoxName || boxName == guarantorBoxName || boxName == mediaBoxName) {
          await box.clear();
          await box.put(docId, innerMap);
        } else {
          // باقی تمام باکسز (installments, transaction وغیرہ) میں ان کی اصل کیز پر ڈیٹا رکھنا
          for (final record in innerMap.entries) {
            await box.put(record.key, record.value);
          }
        }
      }

      InspectorStore.instance.logPayload(
        title: '$logTitle (DocId: $docId)',
        direction: PayloadDirection.localHiveWrite,
        data: payloads,
      );

      // بیک گراؤنڈ میں فوری سنک پش
      MasterSyncHub.pushAllPendingRecords().catchError((_) {});

      return true;
    } catch (e) {
      return false;
    }
  }

  static List<String> getAllActiveBoxNames() {
    return [
      settingsBoxName,
      usersBoxName,
      stockBoxName,
      appConfigBoxName,
      if (Hive.isBoxOpen(customerBoxName)) customerBoxName,
      if (Hive.isBoxOpen(guarantorBoxName)) guarantorBoxName,
      if (Hive.isBoxOpen(mediaBoxName)) mediaBoxName,
      if (Hive.isBoxOpen(installmentsBoxName)) installmentsBoxName,
      if (Hive.isBoxOpen(transactionBoxName)) transactionBoxName,
    ];
  }
}