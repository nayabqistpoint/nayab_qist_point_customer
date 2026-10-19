import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';
import 'payment_payload_service.dart';

class PaymentStorageHandler {
  PaymentStorageHandler._();

  static Future<Box> ensureAppConfigBoxOpen() async {
    return await HiveBoxManager.openSafeBox(HiveBoxManager.appConfigBoxName);
  }

  static ValueListenable<Box>? get appConfigBoxListenable {
    if (Hive.isBoxOpen(HiveBoxManager.appConfigBoxName)) {
      return Hive.box(HiveBoxManager.appConfigBoxName).listenable();
    }
    return null;
  }

  static Future<dynamic> getAppConfigDoc(String key) async {
    try {
      final box = await ensureAppConfigBoxOpen();
      return box.get(key);
    } catch (e) {
      debugPrint('❌ PaymentStorageHandler Error fetching $key: $e');
      return null;
    }
  }

  static Map<String, dynamic> generateSubmissionPayload({
    required int targetPayable,
    required int splitsSum,
    required int discountAmount,
    required List<Map<String, dynamic>> splits,
    required String note,
    required String receiptImagePath,
    required String voiceNotePath,
    required bool hasPhoto,
    required bool hasAudio,
  }) {
    return PaymentPayloadService.buildPaymentResultMap(
      targetPayable: targetPayable,
      splitsSum: splitsSum,
      discountAmount: discountAmount,
      splits: splits,
      note: note,
      receiptImagePath: receiptImagePath,
      voiceNotePath: voiceNotePath,
      hasPhoto: hasPhoto,
      hasAudio: hasAudio,
    );
  }
}