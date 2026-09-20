import 'package:hive_flutter/hive_flutter.dart';
import '../inspector/inspector_store.dart';
import '../sync/master_sync_hub.dart';

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

  /// 💾 سنگل کلائنٹ پرائیویٹ سیشن رائٹ
  static Future<bool> writeBatchPayloads({
    required String docId, // 🎯 یہ صارف کا موبائل نمبر ہی ہے
    required Map<String, Map<String, dynamic>> payloads,
    String logTitle = 'ڈیٹا لوکل محفوظ ہوا',
  }) async {
    try {
      for (final entry in payloads.entries) {
        final boxName = entry.key;
        final data = entry.value;
        final box = await openSafeBox(boxName);

        // اگر پروفائل باکس ہے تو پرانا ڈیٹا ہٹا کر صرف ایکٹو یوزر کی سنگل کی رکھنا
        if (boxName == customerBoxName || boxName == guarantorBoxName || boxName == mediaBoxName) {
          await box.clear();
        }

        // کی ہمیشہ صارف کا موبائل نمبر رہے گی
        await box.put(docId, data);
      }

      InspectorStore.instance.logPayload(
        title: '$logTitle (Phone: $docId)',
        direction: PayloadDirection.localHiveWrite,
        data: payloads,
      );

      // بیک گراؤنڈ میں فوری پش
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