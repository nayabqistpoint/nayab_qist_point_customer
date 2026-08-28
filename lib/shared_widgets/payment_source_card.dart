import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PaymentRowItem {
  String source;
  final TextEditingController amountController;

  PaymentRowItem({required this.source, String amount = ''})
      : amountController = TextEditingController(text: amount);
}

class PaymentSourceCard extends StatefulWidget {
  final String? selectedSource;
  final List<String> availableBanks;
  final ValueChanged<String?> onChanged;
  final TextEditingController? noteController;
  final ValueChanged<String>? onAttachmentPicked;

  const PaymentSourceCard({
    super.key,
    required this.selectedSource,
    required this.availableBanks,
    required this.onChanged,
    this.noteController,
    this.onAttachmentPicked,
  });

  @override
  State<PaymentSourceCard> createState() => PaymentSourceCardState();
}

class PaymentSourceCardState extends State<PaymentSourceCard> {
  bool _isSplitMode = false;
  final List<PaymentRowItem> _rows = [];
  late final TextEditingController noteController;
  final TextEditingController _singleAmountController = TextEditingController();
  String? _attachedImagePath;

  bool get isSplitMode => _isSplitMode;

  @override
  void initState() {
    super.initState();
    noteController = widget.noteController ?? TextEditingController();
  }

  @override
  void dispose() {
    for (var row in _rows) {
      row.amountController.dispose();
    }
    _singleAmountController.dispose();
    if (widget.noteController == null) noteController.dispose();
    super.dispose();
  }

  void _pickAttachment() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _attachedImagePath = image.path);
      widget.onAttachmentPicked?.call(image.path);
    }
  }

  void _toggleSplitMode(List<String> sources) {
    setState(() {
      _isSplitMode = true;
      _rows.clear();
      final String first = widget.selectedSource ?? sources.first;
      final String second = sources.firstWhere((s) => s != first, orElse: () => sources.first);
      _rows.addAll([
        PaymentRowItem(source: first),
        PaymentRowItem(source: second),
      ]);
    });
  }

  void _addRow(List<String> sources) {
    setState(() {
      final String next = sources.firstWhere(
        (s) => !_rows.any((r) => r.source == s),
        orElse: () => sources.first,
      );
      _rows.add(PaymentRowItem(source: next));
    });
  }

  void _removeRow(int index) {
    setState(() {
      _rows[index].amountController.dispose();
      _rows.removeAt(index);
      if (_rows.length <= 1) {
        _isSplitMode = false;
        if (_rows.isNotEmpty) widget.onChanged(_rows.first.source);
      }
    });
  }

  // 🎯 کل موصول شدہ رقم معلوم کرنے کا گیٹر
  double get totalReceived {
    if (_isSplitMode) {
      return _rows.fold(
          0.0, (total, item) => total + (double.tryParse(item.amountController.text) ?? 0.0));
    } else {
      return double.tryParse(_singleAmountController.text) ?? 0.0;
    }
  }

  List<Map<String, dynamic>> getSplitPaymentsList() {
    if (!_isSplitMode) return [];
    return _rows
        .map((r) => {
              'source': r.source,
              'amount': double.tryParse(r.amountController.text) ?? 0.0,
            })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> banks = widget.availableBanks.isEmpty ? ['Cash'] : widget.availableBanks;
    final String current = (widget.selectedSource != null && banks.contains(widget.selectedSource))
        ? widget.selectedSource!
        : banks.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_isSplitMode) ...[
          Row(
            children: [
              const Text("Payment Type", style: TextStyle(fontSize: 15, color: Colors.black54)),
              const Spacer(),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: current,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: banks.map((s) => _buildDropdownItem(s)).toList(),
                  onChanged: widget.onChanged,
                ),
              ),
              const SizedBox(width: 8),
              const Text("Rs ", style: TextStyle(fontSize: 14, color: Colors.black87)),
              SizedBox(
                width: 85,
                child: TextField(
                  controller: _singleAmountController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: () => _toggleSplitMode(banks),
            child: const Text("+ Add Payment Type",
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
        ] else ...[
          ..._rows.asMap().entries.map((entry) {
            final int idx = entry.key;
            final item = entry.value;
            final String rowCurrent = banks.contains(item.source) ? item.source : banks.first;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: rowCurrent,
                      isDense: true,
                      items: banks.map((s) => _buildDropdownItem(s)).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => item.source = val);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.black45),
                    onPressed: () => _removeRow(idx),
                  ),
                  const Spacer(),
                  const Text("Rs ", style: TextStyle(fontSize: 14, color: Colors.black87)),
                  SizedBox(
                    width: 85,
                    child: TextField(
                      controller: item.amountController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => _addRow(banks),
                child: const Text("+ Add Payment Type",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
              Text("Received Rs ${totalReceived.toStringAsFixed(0)}",
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
        const SizedBox(height: 16),
        const Divider(color: Colors.black12, height: 1),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 60,
                child: TextField(
                  controller: noteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Add Note",
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black26),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: _pickAttachment,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _attachedImagePath != null ? Colors.green : Colors.black26,
                    width: _attachedImagePath != null ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: _attachedImagePath != null ? Colors.green.shade50 : null,
                ),
                child: Icon(
                  _attachedImagePath != null ? Icons.check_circle : Icons.image_outlined,
                  color: _attachedImagePath != null ? Colors.green : Colors.black38,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String source) {
    final bool isCash = source.toLowerCase() == 'cash';
    return DropdownMenuItem<String>(
      value: source,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCash ? Icons.money : Icons.account_balance,
            color: isCash ? Colors.green : Colors.blue[800],
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(source),
        ],
      ),
    );
  }
}