import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';
import 'services/stock_box_service.dart';

class PurchaseMarketController extends ChangeNotifier {
  final StockBoxService _stockService = StockBoxService();
  int expandedCardIndex = -1;

  ValueListenable<Box> get stockListenable => _stockService.listenToStock();
  List<Map<String, dynamic>> getStockDevices() => _stockService.getAllStockDevices();
  int get totalPlansCount => _stockService.getTotalPlansCount();

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
    // 🎯 16.67% کا راؤنڈڈ کم از کم ایڈوانس (100 پر راؤنڈ)
    final int dynamicMinAdv = (((price * 0.1667) / 100).ceil()) * 100;
    
    // اگر کسٹمر نے بغیر ایڈوانس (0) منتخب کیا تو 0 رہے گا، ورنہ کم از کم حد سے کم نہیں ہو سکتا
    final int finalUserAdv = adv == 0 ? 0 : (adv < dynamicMinAdv ? dynamicMinAdv : adv);

    final device = {
      'name': name.isEmpty ? 'کسٹم ڈیوائس تخمینہ' : name,
      'baseValue': price,
      'ramRom': 'کسٹمر ڈیمانڈ',
      'condition': 'نئی یا طلب کے مطابق',
      'warranty': '12 ماہ وارنٹی',
      'minAdvanceRequired': dynamicMinAdv,
      'userCustomAdvance': finalUserAdv,
      'isCustomEstimate': true,
      'images': <String>[],
    };
    navigateToPlanDetail(context, device, customerPhone);
  }
}