import 'package:flutter/material.dart';
import '../services/slots_feed_service.dart';

class LargeSlotsScheduleUi extends StatelessWidget {
  final List<ShowcaseSlotItem> slots;

  const LargeSlotsScheduleUi({
    super.key,
    required this.slots,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('لائیو سلاٹ و ڈلیوری شیڈول', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
            Text('اکتوبر 2026', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0D9488))),
          ],
        ),
        const SizedBox(height: 10),
        ...slots.map((s) => _buildSlotCard(s)),
      ],
    );
  }

  Widget _buildSlotCard(ShowcaseSlotItem s) {
    Color tagBg;
    Color tagColor;

    if (s.isAvailable) {
      tagBg = const Color(0xFFEFF6FF);
      tagColor = const Color(0xFF2563EB);
    } else if (s.tag.contains('جاری')) {
      tagBg = const Color(0xFFFEF3C7);
      tagColor = const Color(0xFFB45309);
    } else {
      tagBg = const Color(0xFFDCFCE7);
      tagColor = const Color(0xFF16A34A);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: s.isAvailable ? const Color(0xFF93C5FD) : const Color(0xFFE2E8F0),
          width: s.isAvailable ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      s.date,
                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    s.token,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  s.tag,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: tagColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                s.isAvailable ? Icons.event_available_rounded : Icons.check_circle_rounded,
                size: 15,
                color: s.isAvailable ? const Color(0xFF2563EB) : const Color(0xFF10B981),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  s.item,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: s.isAvailable ? const Color(0xFF1E40AF) : const Color(0xFF334155),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}