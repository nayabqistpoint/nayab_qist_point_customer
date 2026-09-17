import 'package:flutter/material.dart';
import '../benchmark_controller.dart';

class BenchmarkSidebarUi extends StatelessWidget {
  final BenchmarkController controller;

  const BenchmarkSidebarUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: ListView.builder(
        itemCount: controller.modules.length,
        itemBuilder: (ctx, i) {
          final m = controller.modules[i];
          final isSel = i == controller.selectedIndex;
          return ListTile(
            dense: true,
            selected: isSel,
            selectedTileColor: const Color(0xFFECFDF5),
            leading: Icon(
              Icons.folder_special_rounded,
              size: 18,
              color: isSel ? const Color(0xFF059669) : const Color(0xFF94A3B8),
            ),
            title: Text(
              m.title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                color: isSel ? const Color(0xFF059669) : const Color(0xFF1E293B),
              ),
            ),
            subtitle: Text(
              m.serviceClass,
              style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B), fontFamily: 'monospace'),
            ),
            onTap: () => controller.selectModule(i),
          );
        },
      ),
    );
  }
}