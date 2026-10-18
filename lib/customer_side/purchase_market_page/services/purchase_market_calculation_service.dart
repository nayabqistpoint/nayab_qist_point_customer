import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/services/calculator_config_service.dart';
import 'package:nayab_qist_point_customer/customer_side/device_plan_detail_page/services/plan_math_service.dart';

class PurchaseMarketCalculationService {
  static int getTotalPlansCount() {
    final config = CalculatorConfigService().getConfig();
    return config.allowedDurations.length * 4;
  }

  static int calculateRoundedMinAdvance(int price) {
    if (price <= 0) return 0;
    final double raw = price * 0.1667;
    return ((raw / 100).ceil()) * 100;
  }

  static List<Map<String, dynamic>> parseStockDevices(List<dynamic> rawStockEntries) {
    try {
      final config = CalculatorConfigService().getConfig();
      final List<Map<String, dynamic>> devices = [];

      for (final entry in rawStockEntries) {
        if (entry is! Map) continue;
        final raw = entry['data'];
        final key = entry['key'];

        if (raw is! Map) continue;

        final String statusRaw = raw['status']?.toString().toLowerCase() ?? '';
        if (statusRaw != 'available') continue;

        final int baseValue = (raw['salePrice'] as num?)?.toInt() ?? 0;
        final String conditionType = raw['conditionType']?.toString().toUpperCase() ?? '';
        final String conditionRating = raw['conditionRating']?.toString() ?? '';

        String conditionText = '';
        if (conditionType == 'NEW') {
          conditionText = 'ڈبہ پیک (نیا)';
        } else if (conditionType == 'USED') {
          conditionText = conditionRating.isNotEmpty ? 'استعمال شدہ ($conditionRating)' : 'استعمال شدہ';
        } else if (raw['condition'] != null && raw['condition'].toString().isNotEmpty) {
          conditionText = raw['condition'].toString();
        }

        final int warrantyMonths = (raw['warranty'] as num?)?.toInt() ?? 0;
        final String warrantyText = warrantyMonths > 0
            ? '$warrantyMonths ماہ آفیشل وارنٹی'
            : 'بغیر وارنٹی';

        List<String> imagesList = [];
        if (raw['images'] is List) {
          imagesList = (raw['images'] as List)
              .map((e) => e.toString())
              .where((e) => e.trim().isNotEmpty)
              .toList();
        } else if (raw['images'] is String && (raw['images'] as String).trim().isNotEmpty) {
          imagesList = [(raw['images'] as String).trim()];
        }

        final int principal = PlanMathService.calculatePrincipal(
          baseValue: baseValue,
          config: config,
        );
        final int baseDuration = config.allowedDurations.isNotEmpty ? config.allowedDurations.first : 6;

        final int chequeTotal = PlanMathService.calculateTotalContractPrice(
          principal: principal,
          months: baseDuration,
          isCheque: true,
          config: config,
        );
        final int minAdv = PlanMathService.calculateMinAdvance(
          totalContractPrice: chequeTotal,
          months: baseDuration,
          config: config,
        );
        final int zeroAdvMonthly = PlanMathService.calculateMonthlyEmi(
          totalContractPrice: chequeTotal,
          advancePaid: 0,
          months: baseDuration,
          config: config,
        );
        final int minMonthlyWithAdv = PlanMathService.calculateMonthlyEmi(
          totalContractPrice: chequeTotal,
          advancePaid: minAdv,
          months: baseDuration,
          config: config,
        );

        devices.add({
          'id': raw['itemId']?.toString() ?? key.toString(),
          'name': raw['itemName']?.toString() ?? '',
          'baseValue': baseValue,
          'ramRom': raw['ramRom']?.toString() ?? '',
          'condition': conditionText,
          'status': 'موجود ہے',
          'warranty': warrantyText,
          'color': raw['color']?.toString() ?? '',
          'imeiNo': raw['imeiNo']?.toString() ?? '',
          'minAdvance': minAdv,
          'zeroAdvMonthly': zeroAdvMonthly,
          'minMonthlyWithAdv': minMonthlyWithAdv,
          'images': imagesList,
          'isCustomEstimate': false,
        });
      }
      return devices;
    } catch (_) {
      return const [];
    }
  }

  static Map<String, dynamic> buildCustomEstimateDevice({
    required String name,
    required int price,
    required int adv,
  }) {
    final int dynamicMinAdv = calculateRoundedMinAdvance(price);
    final int finalUserAdv = adv == 0 ? 0 : (adv < dynamicMinAdv ? dynamicMinAdv : adv);

    return {
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
  }
}