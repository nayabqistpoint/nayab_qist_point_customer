import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/benchmark_registry_service.dart';
import '../services/benchmark_live_logger.dart';
import 'benchmark_field_list_ui.dart';

class BenchmarkBoxTabUi extends StatelessWidget {
  final ValueChanged<String>? onPageChipTapped;

  const BenchmarkBoxTabUi({super.key, this.onPageChipTapped});

  void _showDocumentDetail(BuildContext context, String boxName, dynamic key, dynamic value) {
    final Map<String, dynamic> dataMap = value is Map ? Map<String, dynamic>.from(value) : {'value': value};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  const Icon(Icons.description_rounded, color: Color(0xFF0D9488), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('باکس: $boxName', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                        Text('$key', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      final str = BenchmarkLiveLogger.formatJson(dataMap);
                      Clipboard.setData(ClipboardData(text: '// Box: $boxName | Key: $key\n$str'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('डॉक्यूमेंट डेटा कॉपी हो गया!')),
                      );
                    },
                    icon: const Icon(Icons.smart_toy_outlined, size: 12),
                    label: const Text('Copy for AI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  BenchmarkFieldListUi(payload: dataMap),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final boxesMeta = BenchmarkRegistryService.getBoxesMetadata();

    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: boxesMeta.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final meta = boxesMeta[index];
        final bool isOpen = Hive.isBoxOpen(meta.boxName);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1.1),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            shape: const Border(),
            leading: Icon(
              Icons.inventory_2_rounded,
              color: isOpen ? const Color(0xFF0D9488) : const Color(0xFFDC2626),
              size: 20,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    meta.boxName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12.5, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: isOpen ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isOpen ? 'Open' : 'Closed',
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                      color: isOpen ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Text(
              meta.purpose,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
            ),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('اینٹری کے ذمہ دار پیجز:', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: meta.writablePages.map((pageName) {
                        return ActionChip(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                          avatar: const Icon(Icons.open_in_new_rounded, size: 11, color: Color(0xFF1D4ED8)),
                          label: Text(pageName, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8))),
                          backgroundColor: const Color(0xFFEFF6FF),
                          side: const BorderSide(color: Color(0xFFBFDBFE)),
                          onPressed: () {
                            if (onPageChipTapped != null) {
                              onPageChipTapped!(pageName);
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    const Text('لازمی کیز (Primary Keys):', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(
                      meta.primaryKeys.join(' • '),
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: Color(0xFF2563EB), fontWeight: FontWeight.w600),
                    ),
                    if (isOpen) ...[
                      const SizedBox(height: 8),
                      const Divider(),
                      _buildLiveBoxRecords(context, meta.boxName),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLiveBoxRecords(BuildContext context, String boxName) {
    final box = Hive.box(boxName);

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box b, _) {
        final keys = b.keys.toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'کل ریکارڈز: ${keys.length}',
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                ),
                const Text(
                  'تفصیل کے لیے ٹیپ کریں',
                  style: TextStyle(fontSize: 9.5, color: Color(0xFF059669), fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (keys.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Center(
                  child: Text('اس باکس میں فی الحال کوئی ڈیٹا نہیں ہے', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                ),
              )
            else
              Container(
                constraints: const BoxConstraints(maxHeight: 220),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: keys.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  itemBuilder: (ctx, i) {
                    final k = keys[i];
                    final val = b.get(k);

                    return InkWell(
                      onTap: () => _showDocumentDetail(context, boxName, k, val),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text('${i + 1}', style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              flex: 4,
                              child: Text(
                                '$k',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontFamily: 'monospace', fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              flex: 5,
                              child: Text(
                                val is Map ? '{${val.keys.length} keys}' : val.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B)),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 9, color: Color(0xFF94A3B8)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}