import 'package:flutter/material.dart';
import 'benchmark_controller.dart';
import 'components/benchmark_sidebar_ui.dart';
import 'components/benchmark_field_list_ui.dart';

class BenchmarkPage extends StatefulWidget {
  const BenchmarkPage({super.key});

  @override
  State<BenchmarkPage> createState() => _BenchmarkPageState();
}

class _BenchmarkPageState extends State<BenchmarkPage> {
  final controller = BenchmarkController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = controller.activeModule;
    final payload = controller.activePayload;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text('اسٹینڈرڈ پے لوڈ رجسٹری و شیشہ (Service Mirror)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0F172A),
          elevation: 0.5,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2563EB)),
              tooltip: 'ریفریش',
              onPressed: () => controller.refreshData(context),
            ),
            IconButton(
              icon: const Icon(Icons.copy_all_rounded, color: Color(0xFF059669)),
              tooltip: 'JSON کاپی کریں',
              onPressed: () => controller.copyJson(context),
            ),
          ],
        ),
        body: Row(
          children: [
            BenchmarkSidebarUi(controller: controller),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Text(active.title,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      _pill('سروس ماخذ: ${active.serviceClass}', const Color(0xFFEFF6FF), const Color(0xFF1D4ED8)),
                      _pill('کل فیلڈز: ${payload.keys.length}', const Color(0xFFF1F5F9), const Color(0xFF475569)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  BenchmarkFieldListUi(payload: payload),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String label, Color bg, Color text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(5)),
        child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: text)),
      );
}