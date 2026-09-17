import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SubmissionReceiptSheetUi extends StatefulWidget {
  final String title;
  final String subtitle;
  final Map<String, dynamic> rawPayload;
  final Map<String, dynamic>? customerFriendlyPayload;
  final VoidCallback onConfirmAndSubmit;

  const SubmissionReceiptSheetUi({
    super.key,
    required this.title,
    required this.subtitle,
    required this.rawPayload,
    this.customerFriendlyPayload,
    required this.onConfirmAndSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Map<String, dynamic> rawPayload,
    Map<String, dynamic>? customerFriendlyPayload,
    required VoidCallback onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SubmissionReceiptSheetUi(
        title: title,
        subtitle: subtitle,
        rawPayload: rawPayload,
        customerFriendlyPayload: customerFriendlyPayload,
        onConfirmAndSubmit: onConfirm,
      ),
    );
  }

  @override
  State<SubmissionReceiptSheetUi> createState() => _SubmissionReceiptSheetUiState();
}

class _SubmissionReceiptSheetUiState extends State<SubmissionReceiptSheetUi> {
  bool isRawDevMode = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRawDevMode ? TextDirection.ltr : TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.88,
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // ٹاپ کنٹرول بار مع ٹوگل
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.5)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isRawDevMode ? const Color(0xFFEFF6FF) : const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isRawDevMode ? Icons.data_object_rounded : Icons.receipt_long_rounded,
                      color: isRawDevMode ? const Color(0xFF2563EB) : const Color(0xFF059669),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isRawDevMode ? 'Hive / Firebase Raw Payload' : widget.title,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          isRawDevMode ? 'ایگزیکٹ الفابیٹس، کیز اور ڈیٹا ٹائپس' : widget.subtitle,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  // 🎯 کلک ایبل موڈ سوئچر
                  InkWell(
                    onTap: () {
                      setState(() {
                        isRawDevMode = !isRawDevMode;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isRawDevMode ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isRawDevMode ? Icons.visibility : Icons.code,
                            size: 16,
                            color: isRawDevMode ? Colors.white : const Color(0xFF0F172A),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isRawDevMode ? 'کسٹمر ویو' : 'ڈیولپر ویو',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: isRawDevMode ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // باڈی ویو (کسٹمر بمقابلہ را ڈیولپر ویو)
            Expanded(
              child: isRawDevMode ? _buildRawPayloadView() : _buildCustomerView(),
            ),

            // باٹم فائنل بٹن
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onConfirmAndSubmit();
                  },
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                  label: const Text(
                    'ڈیٹا کی تصدیق ہے • آگے پروسیس کریں',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRawPayloadView() {
    final rawJsonStr = const JsonEncoder.withIndent('  ').convert(widget.rawPayload);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            const Text(
              'Field Mapping & Types',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155)),
            ),
            const Spacer(),
            TextButton.icon(
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: const Text('Copy JSON', style: TextStyle(fontSize: 12)),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: rawJsonStr));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Raw JSON کلپ بورڈ پر کاپی ہو گیا!')),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              children: widget.rawPayload.entries.map((entry) {
                final val = entry.value;
                final typeStr = val.runtimeType.toString();

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getTypeBadgeColor(val),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          typeStr,
                          style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: SelectableText(
                          val?.toString() ?? 'null',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: val is bool
                                ? (val ? const Color(0xFF059669) : const Color(0xFFDC2626))
                                : const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerView() {
    final displayData = widget.customerFriendlyPayload ?? widget.rawPayload;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Color(0xFFB45309), size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'محترم کسٹمر! اپنی درج شدہ تفصیلات کی تسلی فرما لیں۔',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF92400E), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              children: displayData.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 130,
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SelectableText(
                          entry.value?.toString() ?? 'خالی',
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Color _getTypeBadgeColor(dynamic val) {
    if (val is bool) return const Color(0xFFD97706);
    if (val is int || val is double) return const Color(0xFF2563EB);
    if (val is List || val is Map) return const Color(0xFF7C3AED);
    return const Color(0xFF64748B);
  }
}