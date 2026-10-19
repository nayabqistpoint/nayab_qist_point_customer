import 'dart:convert';
import 'package:flutter/foundation.dart';

enum BenchmarkPayloadDirection {
  localHiveWrite,
  localHiveRead,
  outToCloud,
  inFromCloud,
}

class BenchmarkRecord {
  final String title;
  final BenchmarkPayloadDirection direction;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  BenchmarkRecord({
    required this.title,
    required this.direction,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  String get timeFormatted {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    final s = timestamp.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

class BenchmarkLiveLogger extends ChangeNotifier {
  static final BenchmarkLiveLogger instance = BenchmarkLiveLogger._internal();
  BenchmarkLiveLogger._internal();

  final List<BenchmarkRecord> _logs = [];

  List<BenchmarkRecord> get logs => List.unmodifiable(_logs.reversed);

  void record({
    required String title,
    required BenchmarkPayloadDirection direction,
    required Map<String, dynamic> data,
  }) {
    _logs.add(BenchmarkRecord(
      title: title,
      direction: direction,
      data: data,
    ));

    if (_logs.length > 50) {
      _logs.removeAt(0);
    }
    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }

  static String formatJson(dynamic data) {
    const encoder = JsonEncoder.withIndent('  ');
    try {
      return encoder.convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}