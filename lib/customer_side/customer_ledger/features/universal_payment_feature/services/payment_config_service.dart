import 'package:flutter/foundation.dart';
import 'payment_storage_handler.dart';

class PaymentConfigService {
  PaymentConfigService._();

  static const List<String> fallbackSources = [
    'دکان کیش دراز',
    'JazzCash',
    'EasyPaisa',
  ];

  static const List<String> fallbackDiscounts = [
    'عام رعایت',
    'خاص رعایت',
  ];

  static Future<List<String>> getPaymentSources() async {
    try {
      final dynamic doc = await PaymentStorageHandler.getAppConfigDoc('banks_config');
      if (doc != null && doc is Map) {
        final dynamic raw = doc['availableBanks'] ?? doc['banks'];
        List<String> list = [];
        if (raw is Map) {
          list = raw.keys.map((k) => k.toString().trim()).where((s) => s.isNotEmpty).toList();
        } else if (raw is List) {
          list = raw
              .map((e) => (e is Map ? (e['name'] ?? e['title'] ?? '') : e).toString().trim())
              .where((s) => s.isNotEmpty)
              .toList();
        }
        if (list.isNotEmpty) return list;
      }
    } catch (e) {
      debugPrint('❌ getPaymentSources Error: $e');
    }
    return fallbackSources;
  }

  static Future<List<String>> getDiscountCategories() async {
    try {
      final dynamic doc = await PaymentStorageHandler.getAppConfigDoc('discounts_config');
      if (doc != null && doc is Map) {
        final dynamic raw = doc['discountCategories'] ?? doc['discounts'];
        List<String> list = [];
        if (raw is Map) {
          list = raw.keys.map((k) => k.toString().trim()).where((s) => s.isNotEmpty).toList();
        } else if (raw is List) {
          list = raw
              .map((e) => (e is Map ? (e['name'] ?? e['title'] ?? '') : e).toString().trim())
              .where((s) => s.isNotEmpty)
              .toList();
        }
        if (list.isNotEmpty) return list;
      }
    } catch (e) {
      debugPrint('❌ getDiscountCategories Error: $e');
    }
    return fallbackDiscounts;
  }
}