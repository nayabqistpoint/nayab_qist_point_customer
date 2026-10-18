import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/services/purchase_market_storage_handler.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/services/purchase_market_calculation_service.dart';

class PurchaseMarketController extends ChangeNotifier {
  int expandedCardIndex = -1;

  ValueListenable<Box>? get boxListenable => PurchaseMarketStorageHandler.boxListenable;

  int get totalPlansCount => PurchaseMarketCalculationService.getTotalPlansCount();

  List<Map<String, dynamic>> getStockDevices() {
    final rawEntries = PurchaseMarketStorageHandler.getAllRawStock();
    return PurchaseMarketCalculationService.parseStockDevices(rawEntries);
  }

  void toggleRibbon(int index) {
    expandedCardIndex = (expandedCardIndex == index) ? -1 : index;
    notifyListeners();
  }

  void navigateToPlanDetail(BuildContext context, Map<String, dynamic> device, String? customerPhone) {
    Navigator.pushNamed(
      context,
      AppRoutes.planDetail,
      arguments: {
        'device': device,
        'customerPhone': customerPhone,
      },
    );
  }

  void handleCustomEstimateSubmit(BuildContext context, String name, int price, int adv, String? customerPhone) {
    final device = PurchaseMarketCalculationService.buildCustomEstimateDevice(
      name: name,
      price: price,
      adv: adv,
    );
    navigateToPlanDetail(context, device, customerPhone);
  }
}