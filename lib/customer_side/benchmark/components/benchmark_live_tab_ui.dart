import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/benchmark_live_logger.dart';

class BenchmarkLiveTabUi extends StatelessWidget {
  const BenchmarkLiveTabUi({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: BenchmarkLiveLogger.instance,
      builder: (context, _) {
        final logs = BenchmarkLiveLogger.instance.logs;

        if (logs.isEmpty) {
          return const Center(
            child: Text(
              'ابھی تک کوئی نیا لائیو پے لوڈ ریکارڈ نہیں ہوا。\nایپ میں کوئی بھی لین دین کریں تاکہ لائیو لاگ یہاں ظاہر ہو۔',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13, height: 1.5),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: logs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final record = logs[index];
            final rawJson = BenchmarkLiveLogger.formatJson(record.data);

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1), width: 1.1),
              ),
              child: ExpansionTile(
                leading: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: const Text('Hive Write 💾', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
                ),
                title: Text(
                  record.title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                subtitle: Text(
                  'وقت: ${record.timeFormatted}  •  کل باکسز/فیلڈز: ${record.data.keys.length}',
                  style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                ),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Captured Raw Payload (Exact Keys):',
                              style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                final textToCopy = '''
// Benchmark Live Payload
// Action: ${record.title}
// Timestamp: ${record.timestamp.toIso8601String()}
$rawJson
''';
                                Clipboard.setData(ClipboardData(text: textToCopy));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('مکمل لاگ کلپ بورڈ پر کاپی ہو گیا! AI کو پیسٹ کر دیں۔'),
                                    backgroundColor: Color(0xFF059669),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.smart_toy_outlined, size: 14),
                              label: const Text('Copy for AI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF059669),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          rawJson,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: Color(0xFF0F172A),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}