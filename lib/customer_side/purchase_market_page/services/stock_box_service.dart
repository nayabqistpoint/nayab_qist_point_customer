import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../device_plan_detail_page/services/calculator_config_service.dart';
import '../../device_plan_detail_page/services/plan_math_service.dart';

class StockBoxService {
  static const String boxName = 'stockBox';
  final CalculatorConfigService _configService = CalculatorConfigService();

  Box get _box {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }
    throw StateError('ہائیو باکس "$boxName" کھلا ہوا نہیں ہے!');
  }

  ValueListenable<Box> listenToStock() {
    return _box.listenable();
  }

  /// کل ڈائنامک پیکجز کی تعداد (مثلاً 28، 32 وغیرہ)
  int getTotalPlansCount() {
    final config = _configService.getConfig();
    return config.allowedDurations.length * 4;
  }

  List<Map<String, dynamic>> getAllStockDevices() {
    try {
      final box = _box;
      final config = _configService.getConfig();
      final List<Map<String, dynamic>> devices = [];

      for (var key in box.keys) {
        final raw = box.get(key);
        if (raw is Map) {
          // صرف دستیاب موبائلز لسٹ میں شامل ہوں
          final String statusRaw = raw['status']?.toString().toLowerCase() ?? '';
          if (statusRaw != 'available') {
            continue;
          }

          final int baseValue = (raw['salePrice'] as num?)?.toInt() ?? 0;
          final String conditionType = raw['conditionType']?.toString().toUpperCase() ?? '';
          final String conditionRating = raw['conditionRating']?.toString() ?? '';

          // کنڈیشن صرف تب بنے گی جب فیلڈ موجود ہو
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
            imagesList = (raw['images'] as List).map((e) => e.toString()).where((e) => e.trim().isNotEmpty).toList();
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
      }
      return devices;
    } catch (_) {
      return [];
    }
  }
}