// lib/customer_side/universal_payments/universal_payment_services/payment_config_service.dart

import 'package:flutter/foundation.dart';
import '../../hive_services/hive_box_manager.dart';

class PaymentConfigService {
  static const List<String> fallbackSources = [
    'دکان کیش دراز',
    'JazzCash',
    'EasyPaisa',
  ];

  static const List<String> fallbackDiscounts = [
    'عام رعایت',
    'خاص رعایت',
  ];

  /// banks_config سے تمام بینک اور سورسز بغیر ترتیب بدلے حاصل کرنا
  static Future<List<String>> getPaymentSources() async {
    try {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.appConfigBoxName);
      final dynamic doc = box.get('banks_config');
      if (doc != null && doc is Map) {
        final dynamic raw = doc['availableBanks'] ?? doc['banks'];
        List<String> list = [];
        if (raw is Map) {
          list = raw.keys.map((k) => k.toString().trim()).where((s) => s.isNotEmpty).toList();
        } else if (raw is List) {
          list = raw.map((e) => (e is Map ? (e['name'] ?? e['title'] ?? '') : e).toString().trim()).where((s) => s.isNotEmpty).toList();
        }

        if (list.isNotEmpty) {
          return list;
        }
      }
    } catch (e) {
      debugPrint('❌ getPaymentSources Error: $e');
    }
    return fallbackSources;
  }

  /// discounts_config سے رعایت کی اقسام حاصل کرنا
  static Future<List<String>> getDiscountCategories() async {
    try {
      final box = await HiveBoxManager.openSafeBox(HiveBoxManager.appConfigBoxName);
      final dynamic doc = box.get('discounts_config');
      if (doc != null && doc is Map) {
        final dynamic raw = doc['discountCategories'] ?? doc['discounts'];
        List<String> list = [];
        if (raw is Map) {
          list = raw.keys.map((k) => k.toString().trim()).where((s) => s.isNotEmpty).toList();
        } else if (raw is List) {
          list = raw.map((e) => (e is Map ? (e['name'] ?? e['title'] ?? '') : e).toString().trim()).where((s) => s.isNotEmpty).toList();
        }
        if (list.isNotEmpty) return list;
      }
    } catch (e) {
      debugPrint('❌ getDiscountCategories Error: $e');
    }
    return fallbackDiscounts;
  }
}