import 'package:flutter/material.dart';

class BenchmarkFieldListUi extends StatelessWidget {
  final Map<String, dynamic> payload;
  final int nestingLevel;

  const BenchmarkFieldListUi({
    super.key,
    required this.payload,
    this.nestingLevel = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (payload.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: const Center(
          child: Text('کوئی فیلڈز موجود نہیں ہیں', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: nestingLevel > 0 ? const Color(0xFFF8FAFC) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: nestingLevel > 0 ? const Color(0xFFE2E8F0) : const Color(0xFFCBD5E1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Column(
          children: payload.entries.toList().asMap().entries.map((item) {
            final idx = item.key + 1;
            final e = item.value;
            final dynamic val = e.value;
            final bool isMap = val is Map;
            final bool isList = val is List;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          nestingLevel > 0 ? '•' : '#$idx',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF475569)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          e.key,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildTypeBadge(val),
                      if (!isMap && !isList) ...[
                        const SizedBox(width: 8),
                        _buildSimpleValue(val),
                      ],
                    ],
                  ),
                  if (isMap) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: BenchmarkFieldListUi(
                        payload: Map<String, dynamic>.from(val),
                        nestingLevel: nestingLevel + 1,
                      ),
                    ),
                  ] else if (isList) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _buildListItemsView(val),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildListItemsView(List list) {
    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('خالی لسٹ [ ]', style: TextStyle(fontSize: 10, color: Color(0xFFBE123C), fontWeight: FontWeight.bold)),
      );
    }

    return Column(
      children: List.generate(list.length, (i) {
        final item = list[i];
        if (item is Map) {
          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFECDD3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE4E6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('آئٹم [$i]', style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFFBE123C))),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                BenchmarkFieldListUi(
                  payload: Map<String, dynamic>.from(item),
                  nestingLevel: nestingLevel + 1,
                ),
              ],
            ),
          );
        }
        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Text('[$i]: ', style: const TextStyle(fontFamily: 'monospace', fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              Expanded(
                child: Text(item?.toString() ?? 'null', style: const TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
              ),
              _buildTypeBadge(item),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTypeBadge(dynamic val) {
    String type = 'String';
    Color bg = const Color(0xFFF1F5F9);
    Color fg = const Color(0xFF475569);
    if (val is bool) {
      type = 'Boolean';
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFFB45309);
    } else if (val is num) {
      type = val is int ? 'Integer' : 'Double';
      bg = const Color(0xFFEFF6FF);
      fg = const Color(0xFF1D4ED8);
    } else if (val is Map) {
      type = 'Map (${val.keys.length})';
      bg = const Color(0xFFFAF5FF);
      fg = const Color(0xFF7E22CE);
    } else if (val is List) {
      type = 'List (${val.length})';
      bg = const Color(0xFFFFF1F2);
      fg = const Color(0xFFBE123C);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(type, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: fg)),
    );
  }

  Widget _buildSimpleValue(dynamic val) {
    return SelectableText(
      val?.toString() ?? 'null',
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: val is bool ? const Color(0xFFD97706) : (val is num ? const Color(0xFF2563EB) : const Color(0xFF0F172A)),
      ),
    );
  }
}