import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxManager {
  // ۱. پبلک گلوبل باکسز (ایپ اسٹارٹ اپ - main.dart)
  static const String settingsBoxName = 'settingsBox';
  static const String usersBoxName = 'usersBox';
  static const String stockBoxName = 'stockBox';
  static const String appConfigBoxName = 'appConfigBox';

  // ۲. یوزر سیشن باکسز (لاگ ان / رجسٹریشن کے بعد)
  static const String customerBoxName = 'customerBox';
  static const String guarantorBoxName = 'guarantorBox';
  static const String mediaBoxName = 'mediaBox';
  static const String installmentsBoxName = 'installmentsBox';
  static const String transactionBoxName = 'transactionBox';

  /// 🚀 ایپ بوٹ اپ پر صرف گلوبل باکسز کھولنا
  static Future<void> initGlobalBoxes() async {
    await Hive.initFlutter();
    await Future.wait([
      openSafeBox(settingsBoxName),
      openSafeBox(usersBoxName),
      openSafeBox(stockBoxName),
      openSafeBox(appConfigBoxName),
    ]);
  }

  /// 🔓 لاگ ان کامیاب ہونے پر صارف کے مخصوص سیشن باکسز کھولنا
  static Future<void> openSessionBoxes() async {
    await Future.wait([
      openSafeBox(customerBoxName),
      openSafeBox(guarantorBoxName),
      openSafeBox(mediaBoxName),
      openSafeBox(installmentsBoxName),
      openSafeBox(transactionBoxName),
    ]);
  }

  /// 🔒 لاگ آؤٹ پر تمام سیشن باکسز کو بحفاظت بند کرنا
  static Future<void> closeSessionBoxes() async {
    await Future.wait([
      _closeSafeBox(customerBoxName),
      _closeSafeBox(guarantorBoxName),
      _closeSafeBox(mediaBoxName),
      _closeSafeBox(installmentsBoxName),
      _closeSafeBox(transactionBoxName),
    ]);
  }

  /// باکس کو بغیر کریش (Safe Mode) میں کھولنا
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

  /// 🔍 انسپکٹر UI کے لیے تمام فعال باکسز کی فہرست
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