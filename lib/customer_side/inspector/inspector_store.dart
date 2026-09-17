import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../hive_services/hive_box_manager.dart';

enum PayloadDirection { outToCloud, inFromCloud, localHiveWrite, localHiveRead }

class PayloadRecord {
  final String title;
  final PayloadDirection direction;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  PayloadRecord({
    required this.title,
    required this.direction,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class InspectorStore extends ChangeNotifier {
  static final InspectorStore instance = InspectorStore._internal();
  InspectorStore._internal();

  final List<PayloadRecord> _history = [];
  List<PayloadRecord> get history => List.unmodifiable(_history.reversed);

  void logPayload({
    required String title,
    required PayloadDirection direction,
    required Map<String, dynamic> data,
  }) {
    _history.add(PayloadRecord(
      title: title,
      direction: direction,
      data: data,
    ));

    // میموری میں صرف آخری 50 ریکارڈز رکھیں
    if (_history.length > 50) {
      _history.removeAt(0);
    }
    notifyListeners();
  }

  void clearLogs() {
    _history.clear();
    notifyListeners();
  }

  // 🎯 انسپکٹر اسکرین کے لیے لائیو باکسز کی فہرست حاصل کرنا
  List<String> getAvailableBoxes() {
    return HiveBoxManager.getAllActiveBoxNames();
  }

  // 🎯 کسی بھی باکس کا لائیو ڈیٹا میپ کی شکل میں پڑھنا
  Map<String, dynamic> getBoxContents(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      return {'status': 'باکس فی الحال بند ہے یا اوپن نہیں ہوا'};
    }
    final box = Hive.box(boxName);
    final Map<String, dynamic> contents = {};
    for (final key in box.keys) {
      contents[key.toString()] = box.get(key);
    }
    return contents;
  }

  static String formatJson(Map<String, dynamic> data) {
    const encoder = JsonEncoder.withIndent('  ');
    try {
      return encoder.convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}