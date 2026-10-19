import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/benchmark_registry_service.dart';
import '../services/benchmark_live_logger.dart';

class BenchmarkAppBarUi extends StatelessWidget implements PreferredSizeWidget {
  final int activeTabIndex;
  final VoidCallback onClearLogs;

  const BenchmarkAppBarUi({
    super.key,
    required this.activeTabIndex,
    required this.onClearLogs,
    required VoidCallback onCopyAll,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  void _executeMasterCopyForAi(BuildContext context) {
    String output = '';

    if (activeTabIndex == 0) {
      // 🎯 टैब 1: सारे 6 पेजों के पेलोड स्कीमा एक साथ AI के लिए
      final pages = BenchmarkRegistryService.getRegisteredPages();
      final Map<String, dynamic> fullPagesMap = {};
      for (final p in pages) {
        fullPagesMap[p.title] = {
          'targetBoxes': p.targetBoxes,
          'payload': p.samplePayload(),
        };
      }
      output = '''
// ==========================================
// BENCHMARK MASTER SCHEMA: ALL PAGES (6)
// ==========================================
${BenchmarkLiveLogger.formatJson(fullPagesMap)}
''';
    } else if (activeTabIndex == 1) {
      // 🎯 टैब 2: सारे ऐक्टिव हाइव बॉक्सेज का लाइव डेटा AI के लिए
      final boxesMeta = BenchmarkRegistryService.getBoxesMetadata();
      final Map<String, dynamic> liveBoxesDump = {};

      for (final meta in boxesMeta) {
        if (Hive.isBoxOpen(meta.boxName)) {
          final b = Hive.box(meta.boxName);
          final Map<String, dynamic> boxContents = {};
          for (final k in b.keys) {
            boxContents[k.toString()] = b.get(k);
          }
          liveBoxesDump[meta.boxName] = {
            'recordsCount': b.keys.length,
            'primaryKeys': meta.primaryKeys,
            'data': boxContents,
          };
        } else {
          liveBoxesDump[meta.boxName] = {'status': 'CLOSED'};
        }
      }
      output = '''
// ==========================================
// BENCHMARK LIVE HIVE STORAGE DUMP (ALL BOXES)
// ==========================================
${BenchmarkLiveLogger.formatJson(liveBoxesDump)}
''';
    } else {
      // 🎯 टैब 3: लाइव फ्लाइट रिकॉर्डर के सारे लॉग्स AI के लिए
      final logs = BenchmarkLiveLogger.instance.logs;
      final logsList = logs.map((l) => {
        'title': l.title,
        'time': l.timeFormatted,
        'data': l.data,
      }).toList();

      output = '''
// ==========================================
// BENCHMARK LIVE FLIGHT RECORDER LOGS (${logs.length})
// ==========================================
${BenchmarkLiveLogger.formatJson(logsList)}
''';
    }

    Clipboard.setData(ClipboardData(text: output));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          activeTabIndex == 0
              ? 'تمام 6 پیجز کا اسکیما AI کے لیے کاپی ہو گیا!'
              : (activeTabIndex == 1
                  ? 'تمام ہائیو باکسز کا لائیو ڈیٹا AI کے لیے کاپی ہو گیا!'
                  : 'تمام فلائٹ لاگز AI کے لیے کاپی ہو گئے!'),
        ),
        backgroundColor: const Color(0xFF059669),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF0F172A),
      title: const Text(
        'بینچ مارک کنٹرول ٹاور',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
      ),
      actions: [
        if (activeTabIndex == 2)
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded, color: Color(0xFFDC2626), size: 20),
            tooltip: 'لاگز صاف کریں',
            onPressed: onClearLogs,
          ),
        // 🎯 मास्टर Copy for AI बटन
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: ElevatedButton.icon(
            onPressed: () => _executeMasterCopyForAi(context),
            icon: const Icon(Icons.smart_toy_rounded, size: 14),
            label: const Text('Copy for AI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              foregroundColor: const Color(0xFF5EEAD4),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}