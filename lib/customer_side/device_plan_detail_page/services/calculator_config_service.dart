import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'calculator_config_model.dart';

class CalculatorConfigService {
  static const String boxName = 'appConfigBox';
  static const String configDocKey = 'calculator_config';

  Box? _box;

  /// ہائیو باکس تک رسائی کو یقینی بنانا
  Box get _configBox {
    if (_box != null && _box!.isOpen) return _box!;
    if (Hive.isBoxOpen(boxName)) {
      _box = Hive.box(boxName);
      return _box!;
    }
    throw StateError('ہائیو باکس "$boxName" کھلا ہوا نہیں ہے!');
  }

  /// موجودہ ڈاکیومنٹ ڈیٹا لے کر ماڈل تیار کرنا
  CalculatorConfigModel getConfig() {
    try {
      final box = _configBox;
      final rawData = box.get(configDocKey);
      if (rawData is Map) {
        return CalculatorConfigModel.fromMap(rawData);
      }
    } catch (_) {}
    return CalculatorConfigModel.fallback();
  }

  /// ریئل ٹائم لسنر (جب ایڈمن کی تبدیلی سنک ہو کر ہائیو میں آئے گی)
  ValueListenable<Box> listenToConfig() {
    return _configBox.listenable(keys: [configDocKey]);
  }
}