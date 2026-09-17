import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'inspector_store.dart';

// 🎯 ری فیکٹر شدہ نئے بینچ مارک پیج کا امپورٹ
import '../benchmark/benchmark_page.dart';

class FloatingInspectorUi extends StatelessWidget {
  const FloatingInspectorUi({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FloatingInspectorUi(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.5)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.bug_report_rounded, color: Color(0xFF059669), size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'لائیو پے لوڈ و Hive مانیٹر',
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.menu_book_rounded, color: Color(0xFF2563EB), size: 22),
                    tooltip: 'تمام پیجز کے معیاری پے لوڈز (Benchmark)',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BenchmarkPage()),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFDC2626), size: 24),
                    onPressed: () => InspectorStore.instance.clearLogs(),
                    tooltip: 'ہسٹری صاف کریں',
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: const TabBar(
                indicatorColor: Color(0xFF059669),
                indicatorWeight: 3,
                labelColor: Color(0xFF059669),
                unselectedLabelColor: Color(0xFF64748B),
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                tabs: [
                  Tab(text: 'لائیو پے لوڈز (Payloads)'),
                  Tab(text: 'Hive لوکل اسٹوریج'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPayloadMonitor(),
                  _buildHiveStorageMonitor(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayloadMonitor() {
    return ListenableBuilder(
      listenable: InspectorStore.instance,
      builder: (context, _) {
        final logs = InspectorStore.instance.history;
        if (logs.isEmpty) {
          return const Center(
            child: Text(
              'ابھی تک کوئی نیا پے لوڈ موصول نہیں ہوا',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final record = logs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  iconColor: const Color(0xFF0F172A),
                  collapsedIconColor: const Color(0xFF64748B),
                  leading: _buildDirectionBadge(record.direction),
                  title: Text(
                    record.title,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.5,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'وقت: ${record.timestamp.hour}:${record.timestamp.minute.toString().padLeft(2, '0')}:${record.timestamp.second.toString().padLeft(2, '0')}  •  فیلڈز: ${record.data.keys.length}',
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(11)),
                        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                      child: SelectableText(
                        InspectorStore.formatJson(record.data),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: Color(0xFF0F172A),
                          fontSize: 13.5,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHiveStorageMonitor() {
    final activeBoxes = InspectorStore.instance.getAvailableBoxes();

    if (activeBoxes.isEmpty) {
      return const Center(
        child: Text(
          'کوئی فعال Hive باکس موجود نہیں ہے',
          style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(14),
      children: activeBoxes.map((boxName) {
        if (!Hive.isBoxOpen(boxName)) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: Text(
              '$boxName (باکس بند ہے)',
              style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13, fontWeight: FontWeight.bold),
            ),
          );
        }

        final box = Hive.box(boxName);
        return ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box b, _) {
            final keys = b.keys.toList();
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
              ),
              child: Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: const Icon(Icons.storage_rounded, color: Color(0xFFD97706), size: 22),
                  title: Text(
                    'باکس: $boxName (${keys.length} آئٹمز)',
                    style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 14.5),
                  ),
                  children: keys.map((key) {
                    final val = b.get(key);
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$key: ',
                            style: const TextStyle(
                              color: Color(0xFF059669),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Expanded(
                            child: SelectableText(
                              val is Map ? InspectorStore.formatJson(Map<String, dynamic>.from(val)) : val.toString(),
                              style: const TextStyle(
                                color: Color(0xFF334155),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildDirectionBadge(PayloadDirection direction) {
    Color bg;
    Color border;
    Color text;
    String label;

    switch (direction) {
      case PayloadDirection.outToCloud:
        bg = const Color(0xFFEFF6FF);
        border = const Color(0xFF93C5FD);
        text = const Color(0xFF1D4ED8);
        label = 'کلاؤڈ ⬆';
        break;
      case PayloadDirection.inFromCloud:
        bg = const Color(0xFFECFDF5);
        border = const Color(0xFFA7F3D0);
        text = const Color(0xFF047857);
        label = 'کلاؤڈ ⬇';
        break;
      case PayloadDirection.localHiveWrite:
        bg = const Color(0xFFFFFBEB);
        border = const Color(0xFFFDE68A);
        text = const Color(0xFFB45309);
        label = 'Hive محفوظ 💾';
        break;
      case PayloadDirection.localHiveRead:
        bg = const Color(0xFFFAF5FF);
        border = const Color(0xFFE9D5FF);
        text = const Color(0xFF7E22CE);
        label = 'Hive پڑھا 📖';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: text, fontSize: 10.5, fontWeight: FontWeight.bold),
      ),
    );
  }
}