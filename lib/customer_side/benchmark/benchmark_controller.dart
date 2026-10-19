import 'package:flutter/material.dart';
import 'benchmark_args.dart';
import 'services/benchmark_live_logger.dart';

class BenchmarkController extends ChangeNotifier {
  final BenchmarkArgs args;
  late int currentTabIndex;

  BenchmarkController({BenchmarkArgs? args}) : args = args ?? const BenchmarkArgs() {
    currentTabIndex = this.args.initialTabIndex;
  }

  void setTab(int index) {
    currentTabIndex = index;
    notifyListeners();
  }

  void clearLogs() {
    BenchmarkLiveLogger.instance.clearLogs();
  }
}