import 'package:flutter/material.dart';

class MobileSelectorDropdownUi extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final int selectedIndex;
  final ValueChanged<int?> onChanged;

  const MobileSelectorDropdownUi({
    super.key,
    required this.products,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    final int safeIndex = (selectedIndex >= 0 && selectedIndex < products.length)
        ? selectedIndex
        : 0;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.phone_iphone_rounded, size: 16, color: Color(0xFF0D9488)),
            const SizedBox(width: 6),
            const Text(
              'موبائل کھاتہ:',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: safeIndex,
                  isDense: true,
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 6,
                  icon: const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFF1E293B)),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  items: List.generate(
                    products.length,
                    (i) => DropdownMenuItem(
                      value: i,
                      child: Text(
                        products[i]['name']?.toString() ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  onChanged: onChanged,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 🎯 کسٹمر کے کل موبائلز کا متحرک بیج
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Text(
                '${safeIndex + 1} از ${products.length} فون',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC2626),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}