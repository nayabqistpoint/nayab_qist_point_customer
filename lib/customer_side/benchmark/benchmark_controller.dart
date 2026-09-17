import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/benchmark_registry_service.dart';

class BenchmarkController extends ChangeNotifier {
  int selectedIndex = 0;
  int refreshTick = 0;

  List<BenchmarkModule> get modules => BenchmarkRegistryService.getModules();
  BenchmarkModule get activeModule => modules[selectedIndex];
  Map<String, dynamic> get activePayload => activeModule.payloadBuilder();

  void selectModule(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void refreshData(BuildContext context) {
    refreshTick++;
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سروس کا تازہ ترین ڈیٹا لوڈ ہو گیا!'),
        duration: Duration(milliseconds: 700),
      ),
    );
  }

  void copyJson(BuildContext context) {
    final jsonStr = const JsonEncoder.withIndent('  ').convert(activePayload);
    Clipboard.setData(ClipboardData(text: jsonStr));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${activeModule.title} کا پے لوڈ کاپی ہو گیا!')),
    );
  }
}