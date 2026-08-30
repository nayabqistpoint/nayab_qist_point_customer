import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/ledger/purchase_now/item_package_ui.dart';
import 'package:nayab_qist_point_customer/services/purchase_now_sync_service.dart';

class PurchaseNowController {
  // پیکج یو آئی کی گلوبل کی (Key)
  final GlobalKey<ItemPackageUIState> packageKey = GlobalKey<ItemPackageUIState>();

  /// پرچیز ریکوئسٹ سبمٹ کرنے کا کنٹرولر میتھڈ
  Future<void> submitPurchaseRequest({
    required String customerMobileNumber,
    required VoidCallback onSuccess,
    required Function(String error) onError,
  }) async {
    Map<String, dynamic> packageData = {};

    if (packageKey.currentState != null) {
      final state = packageKey.currentState!;
      // اگر شِفٹر/ٹوگل میتھڈ موجود ہے تو اسے آن کریں
      state.setPurchaseRequested(true);
      final extractedData = state.getPackageData();
      if (extractedData.isNotEmpty) {
        packageData = Map<String, dynamic>.from(extractedData);
      }
    }

    // 🎯 پے لوڈ بنانے اور سیو کرنے کا تمام کام SyncService کے سپرد کر دیا گیا ہے
    bool isSuccess = await PurchaseNowSyncService.processAndSavePurchaseRequest(
      customerMobileNumber: customerMobileNumber,
      rawPackageData: packageData,
      onError: onError,
    );

    if (isSuccess) {
      onSuccess();
    }
  }
}