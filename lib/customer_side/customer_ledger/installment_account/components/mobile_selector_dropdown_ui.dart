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
        width: double.infinity,
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Row(
          children: [
            const Icon(Icons.phone_iphone_rounded, size: 15, color: Color(0xFF0D9488)),
            const SizedBox(width: 4),
            const Text(
              'کھاتہ:',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
            ),
            const SizedBox(width: 6),
            // 🌟 Expanded کے اندر Dropdown تاکہ جتنی بھی تنگ اسکرین ہو ٹیکسٹ اندر ہی سمٹ جائے
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: safeIndex,
                  isDense: true,
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 6,
                  icon: const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFF1E293B), size: 20),
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
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
            const SizedBox(width: 6),
            // 🎯 کسٹمر کے کل موبائلز کا بیج (FittedBox تاکہ اوور فلو نہ ہو)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xFFFCA5A5), width: 0.8),
                ),
                child: Text(
                  '${safeIndex + 1}/${products.length}',
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}