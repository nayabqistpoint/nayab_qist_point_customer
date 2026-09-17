import 'dart:convert';
import 'package:flutter/material.dart';

class BenchmarkFieldListUi extends StatelessWidget {
  final Map<String, dynamic> payload;

  const BenchmarkFieldListUi({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Column(
          children: payload.entries.toList().asMap().entries.map((item) {
            final idx = item.key + 1;
            final e = item.value;
            final isComplex = e.value is Map || e.value is List;

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
                        width: 28,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '#$idx',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.5,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 🎯 اوور فلو سے بچاؤ کے لیے Expanded اور TextOverflow.ellipsis
                      Expanded(
                        child: Text(
                          e.key,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildTypeBadge(e.value),
                      if (!isComplex) ...[
                        const SizedBox(width: 8),
                        _buildSimpleValue(e.value),
                      ],
                    ],
                  ),
                  if (isComplex) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: SelectableText(
                        const JsonEncoder.withIndent('  ').convert(e.value),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: Color(0xFF0F172A),
                          height: 1.4,
                        ),
                      ),
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
      type = 'Object (Map)';
      bg = const Color(0xFFFAF5FF);
      fg = const Color(0xFF7E22CE);
    } else if (val is List) {
      type = 'Array (List)';
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
        color: val is bool ? const Color(0xFFD97706) : const Color(0xFF0F172A),
      ),
    );
  }
}