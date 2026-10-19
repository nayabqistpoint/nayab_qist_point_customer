import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/benchmark_registry_service.dart';
import '../services/benchmark_live_logger.dart';
import 'benchmark_field_list_ui.dart';

class BenchmarkPageTabUi extends StatefulWidget {
  const BenchmarkPageTabUi({super.key});

  @override
  State<BenchmarkPageTabUi> createState() => _BenchmarkPageTabUiState();
}

class _BenchmarkPageTabUiState extends State<BenchmarkPageTabUi> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = BenchmarkRegistryService.getRegisteredPages();
    final active = pages[selectedIndex];
    final payload = active.samplePayload();
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 500;

    Widget buildSidebar() {
      return Container(
        width: isSmallScreen ? double.infinity : 200,
        height: isSmallScreen ? 140 : double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: isSmallScreen ? BorderSide.none : const BorderSide(color: Color(0xFFE2E8F0)),
            bottom: isSmallScreen ? const BorderSide(color: Color(0xFFE2E8F0)) : BorderSide.none,
          ),
        ),
        child: ListView.builder(
          scrollDirection: isSmallScreen ? Axis.horizontal : Axis.vertical,
          itemCount: pages.length,
          itemBuilder: (ctx, i) {
            final item = pages[i];
            final isSel = i == selectedIndex;

            if (isSmallScreen) {
              return Padding(
                padding: const EdgeInsets.all(6),
                child: ChoiceChip(
                  label: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                      color: isSel ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  selected: isSel,
                  selectedColor: const Color(0xFF059669),
                  backgroundColor: const Color(0xFFF1F5F9),
                  onSelected: (_) => setState(() => selectedIndex = i),
                ),
              );
            }

            return ListTile(
              dense: true,
              selected: isSel,
              selectedTileColor: const Color(0xFFECFDF5),
              leading: Icon(
                Icons.article_rounded,
                size: 16,
                color: isSel ? const Color(0xFF059669) : const Color(0xFF94A3B8),
              ),
              title: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                  color: isSel ? const Color(0xFF059669) : const Color(0xFF1E293B),
                ),
              ),
              onTap: () => setState(() => selectedIndex = i),
            );
          },
        ),
      );
    }

    Widget buildContent() {
      return ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        active.title,
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        final str = BenchmarkLiveLogger.formatJson(payload);
                        Clipboard.setData(ClipboardData(text: '// Page: ${active.title}\n$str'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('JSON कॉपी हो गया!')),
                        );
                      },
                      icon: const Icon(Icons.copy_rounded, size: 12),
                      label: const Text('Copy JSON', style: TextStyle(fontSize: 10)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: active.targetBoxes.map((b) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      b,
                      style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          BenchmarkFieldListUi(payload: payload),
        ],
      );
    }

    if (isSmallScreen) {
      return Column(
        children: [
          buildSidebar(),
          Expanded(child: buildContent()),
        ],
      );
    }

    return Row(
      children: [
        buildSidebar(),
        Expanded(child: buildContent()),
      ],
    );
  }
}