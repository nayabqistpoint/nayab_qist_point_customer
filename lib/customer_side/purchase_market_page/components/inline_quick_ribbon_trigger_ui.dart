import 'package:flutter/material.dart';

class InlineQuickRibbonTriggerUi extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const InlineQuickRibbonTriggerUi({
    super.key,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isExpanded ? const Color(0xFFF0FDFA) : const Color(0xFFF8FAFC),
          border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(13),
            bottomRight: Radius.circular(13),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isExpanded ? Icons.keyboard_double_arrow_up_rounded : Icons.table_chart_outlined,
                  size: 14,
                  color: const Color(0xFF0D9488),
                ),
                const SizedBox(width: 5),
                Text(
                  isExpanded ? 'فوری موازنہ بند کریں' : 'سب سے سستے 6 ماہ کے 2 پلانز دیکھیں',
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                ),
              ],
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: const Color(0xFF64748B),
            ),
          ],
        ),
      ),
    );
  }
}