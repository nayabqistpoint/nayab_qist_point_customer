import 'package:flutter/foundation.dart';
import 'core/connectivity_service.dart';
import 'core/sync_status.dart';
import 'global_sync/app_config_pull_service.dart';
import 'global_sync/stock_pull_service.dart';
import 'media_sync/pending_media_sync_service.dart'; // 👈 کلاؤڈنری میڈیا اپ لوڈ ورکر
import 'pull_services/users_pull_service.dart';
import 'pull_services/customer_pull_service.dart';
import 'pull_services/guarantor_pull_service.dart';
import 'pull_services/installments_pull_service.dart';
import 'pull_services/transaction_pull_service.dart';
import 'pull_services/media_pull_service.dart';
import 'push_services/users_push_service.dart';
import 'push_services/customer_push_service.dart';
import 'push_services/guarantor_push_service.dart';
import 'push_services/installments_push_service.dart';
import 'push_services/transaction_push_service.dart';
import 'push_services/media_push_service.dart';
import 'push_services/atomic_batch_sync_service.dart';

export 'push_services/atomic_batch_sync_service.dart' show BatchOperationItem;
export 'core/sync_status.dart';

class MasterSyncHub {
  // ۱. اٹامک بیچ رائٹ (فوری ڈیٹا سیو + فائر اسٹور کمٹ)
  static Future<SyncResult> executeBatch(List<BatchOperationItem> operations) async {
    return await AtomicBatchSyncService.executeBatch(operations);
  }

  // ۲. گلوبل ڈیٹا سنک (ایپ اسٹارٹ پر اسٹاک اور کنفگ لسن کرنا)
  static Future<void> syncGlobalDataOnBoot() async {
    if (!await ConnectivityService.hasInternetConnection()) return;
    debugPrint('🚀 گلوبل ڈیٹا لائیو سنک شروع...');
    AppConfigPullService.startLiveSync();
    StockPullService.startLiveSync();
  }

  // ۳. سیشن سنک (آف لائن شیلڈ کے ساتھ مکمل محفوظ سنک)
  static Future<void> syncCustomerSession({required String customerPhone}) async {
    // 🛡️ اگر انٹرنیٹ نہیں ہے تو لوکل ہائیو ڈسک کا محفوظ ڈیٹا ہی استعمال ہوگا (ڈیلیٹ نہیں ہوگا)
    if (!await ConnectivityService.hasInternetConnection()) {
      debugPrint('🌐 آف لائن موڈ: لوکل ہائیو ڈسک ڈیٹا محفوظ اور فعال ہے۔');
      return;
    }

    // الف: اگر انٹرنیٹ ہے تو پہلے تمام غیر سنک شدہ ریکارڈز کلاؤڈ پر پش کریں
    await pushAllPendingRecords();

    // ب: تمام سیشن باکسز کے لائیو ریل ٹائم لسنرز (مع مرر ڈیلیٹ) شروع کریں
    UsersPullService.startLiveSync(customerPhone);
    CustomerPullService.startLiveSync(customerPhone);
    GuarantorPullService.startLiveSync(customerPhone);
    InstallmentsPullService.startLiveSync(customerPhone);
    TransactionPullService.startLiveSync(customerPhone);
    MediaPullService.startLiveSync(customerPhone);

    debugPrint('⚡ کسٹمر سیشن کے تمام لائیو لسنرز فعال ہو گئے برائے: $customerPhone');
  }

  // ۴. بیک گراؤنڈ پش ورکر (غیر سنک شدہ یا اٹکے ہوئے ریکارڈز بھیجنا)
  static Future<void> pushAllPendingRecords() async {
    if (!await ConnectivityService.hasInternetConnection()) return;
    debugPrint('📤 پینڈنگ ریکارڈز پش ہو رہے ہیں...');

    // مرحلہ الف: پہلے وہ پینڈنگ فائلیں کلاؤڈنری پر اپ لوڈ ہوں جن کا اسٹیٹس 'pending_upload' ہے
    await PendingMediaSyncService.processPendingUploads();

    // مرحلہ ب: کلاؤڈنری سے لنکس آنے کے بعد تمام باکسز فائر اسٹور پر پش ہوں گے
    await Future.wait([
      UsersPushService.pushPending(),
      CustomerPushService.pushPending(),
      GuarantorPushService.pushPending(),
      InstallmentsPushService.pushPending(),
      TransactionPushService.pushPending(),
      MediaPushService.pushPending(),
    ]);
  }

  // ۵. لاگ آؤٹ پر تمام لائیو لسنرز کو محفوظ طریقے سے بند کرنا
  static void stopAllLiveSyncs() {
    AppConfigPullService.stopLiveSync();
    StockPullService.stopLiveSync();
    UsersPullService.stopLiveSync();
    CustomerPullService.stopLiveSync();
    GuarantorPullService.stopLiveSync();
    InstallmentsPullService.stopLiveSync();
    TransactionPullService.stopLiveSync();
    MediaPullService.stopLiveSync();
    debugPrint('🛑 تمام لائیو لسنرز بند کر دیے گئے۔');
  }
}