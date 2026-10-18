import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PurchaseMarketStorageHandler {
  static const String boxName = 'stockBox';

  static bool get isBoxOpen => Hive.isBoxOpen(boxName);

  static Box get box {
    if (isBoxOpen) {
      return Hive.box(boxName);
    }
    throw StateError('ہائیو باکس "$boxName" کھلا ہوا نہیں ہے!');
  }

  static ValueListenable<Box>? get boxListenable {
    return isBoxOpen ? box.listenable() : null;
  }

  static List<dynamic> getAllRawStock() {
    if (!isBoxOpen) return const [];
    try {
      final currentBox = box;
      return currentBox.keys.map((k) {
        final val = currentBox.get(k);
        return {'key': k, 'data': val};
      }).toList();
    } catch (_) {
      return const [];
    }
  }
}