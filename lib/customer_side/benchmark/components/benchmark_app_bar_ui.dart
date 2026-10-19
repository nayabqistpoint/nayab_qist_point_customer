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

  void _copyAllPagesSchema(BuildContext context) {
    final pages = BenchmarkRegistryService.getRegisteredPages();
    final Map<String, dynamic> fullPagesMap = {};
    for (final p in pages) {
      fullPagesMap[p.title] = {
        'folder': p.featureFolder,
        'targetBoxes': p.targetBoxes,
        'schema': p.samplePayload(),
      };
    }
    final text = '// تمام 7 پیجز کا آفیشل پے لوڈ اسکیما\n${BenchmarkLiveLogger.formatJson(fullPagesMap)}';
    Clipboard.setData(ClipboardData(text: text));
    _showToast(context, 'تمام پیجز کا پے لوڈ اسکیما AI کے لیے کاپی ہو گیا!');
  }

  void _copyAllBoxesDump(BuildContext context) {
    final boxesMeta = BenchmarkRegistryService.getBoxesMetadata();
    final Map<String, dynamic> liveDump = {};
    for (final meta in boxesMeta) {
      if (Hive.isBoxOpen(meta.boxName)) {
        final b = Hive.box(meta.boxName);
        final Map<String, dynamic> data = {};
        for (final k in b.keys) {
          data[k.toString()] = b.get(k);
        }
        liveDump[meta.boxName] = {
          'status': 'OPEN',
          'totalRecords': b.keys.length,
          'primaryKeys': meta.primaryKeys,
          'data': data,
        };
      } else {
        liveDump[meta.boxName] = {'status': 'CLOSED', 'primaryKeys': meta.primaryKeys};
      }
    }
    final text = '// ہائیو کے تمام 9 باکسز کا لائیو ڈیٹا ڈمپ\n${BenchmarkLiveLogger.formatJson(liveDump)}';
    Clipboard.setData(ClipboardData(text: text));
    _showToast(context, 'تمام 9 ہائیو باکسز کا لائیو ڈیٹا AI کے لیے کاپی ہو گیا!');
  }

  void _copyBoxMatrixChart(BuildContext context) {
    final boxesMeta = BenchmarkRegistryService.getBoxesMetadata();
    final Map<String, dynamic> matrix = {};
    for (final meta in boxesMeta) {
      matrix[meta.boxName] = {
        'purpose': meta.purpose,
        'incomingPages': meta.writablePages,
        'requiredKeys': meta.primaryKeys,
      };
    }
    final text = '// باکس بمقابلہ پیجز میپنگ میٹرکس\n${BenchmarkLiveLogger.formatJson(matrix)}';
    Clipboard.setData(ClipboardData(text: text));
    _showToast(context, 'باکسز میپنگ میٹرکس AI کے لیے کاپی ہو گیا!');
  }

  void _copyFlightLogs(BuildContext context) {
    final logs = BenchmarkLiveLogger.instance.logs;
    final list = logs.map((l) => {'title': l.title, 'time': l.timeFormatted, 'data': l.data}).toList();
    final text = '// لائیو فلائٹ ریکارڈر لاگز (${logs.length})\n${BenchmarkLiveLogger.formatJson(list)}';
    Clipboard.setData(ClipboardData(text: text));
    _showToast(context, 'تمام فلائٹ لاگز AI کے لیے کاپی ہو گئے!');
  }

  void _showToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textDirection: TextDirection.rtl),
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
        PopupMenuButton<String>(
          tooltip: 'AI کے لیے کاپی کریں',
          icon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.smart_toy_rounded, color: Color(0xFF5EEAD4), size: 14),
                SizedBox(width: 4),
                Text(
                  'Copy for AI',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF5EEAD4)),
                ),
                Icon(Icons.arrow_drop_down, color: Color(0xFF5EEAD4), size: 16),
              ],
            ),
          ),
          onSelected: (val) {
            switch (val) {
              case 'pages':
                _copyAllPagesSchema(context);
                break;
              case 'boxes':
                _copyAllBoxesDump(context);
                break;
              case 'matrix':
                _copyBoxMatrixChart(context);
                break;
              case 'logs':
                _copyFlightLogs(context);
                break;
            }
          },
          itemBuilder: (ctx) => [
            const PopupMenuItem(
              value: 'pages',
              child: Text('تمام پیجز کا اسکیما کاپی کریں', style: TextStyle(fontSize: 12)),
            ),
            const PopupMenuItem(
              value: 'boxes',
              child: Text('تمام 9 باکسز کا ڈیٹا ڈمپ کاپی کریں', style: TextStyle(fontSize: 12)),
            ),
            const PopupMenuItem(
              value: 'matrix',
              child: Text('باکسز میپنگ میٹرکس کاپی کریں', style: TextStyle(fontSize: 12)),
            ),
            const PopupMenuItem(
              value: 'logs',
              child: Text('فلائٹ لاگز کاپی کریں', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}