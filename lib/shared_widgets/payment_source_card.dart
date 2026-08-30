import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nayab_qist_point_customer/ledger/pay_now/pay_now_controller.dart';

class PaymentSourceCard extends StatefulWidget {
  final PayNowController controller;
  final List<String> availableBanks;

  const PaymentSourceCard({
    super.key,
    required this.controller,
    required this.availableBanks,
  });

  @override
  State<PaymentSourceCard> createState() => _PaymentSourceCardState();
}

class _PaymentSourceCardState extends State<PaymentSourceCard> {
  String? _attachedImagePath;

  void _pickAttachment() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _attachedImagePath = image.path);
      widget.controller.attachmentPath = image.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> banks = widget.availableBanks.isEmpty ? ['Cash'] : widget.availableBanks;
    final String current = banks.contains(widget.controller.selectedPaymentSource)
        ? widget.controller.selectedPaymentSource
        : banks.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.controller.isSplitMode) ...[
          Row(
            children: [
              const Text("Payment Type", style: TextStyle(fontSize: 15, color: Colors.black54)),
              const Spacer(),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: current,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: banks.map((s) => _buildDropdownItem(s)).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        widget.controller.selectedPaymentSource = val;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              const Text("Rs ", style: TextStyle(fontSize: 14, color: Colors.black87)),
              SizedBox(
                width: 85,
                child: TextField(
                  controller: widget.controller.singlePaymentAmountController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
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
            onTap: () => widget.controller.toggleSplitMode(banks),
            child: const Text("+ Add Payment Type",
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
        ] else ...[
          ...widget.controller.splitRows.asMap().entries.map((entry) {
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
                        if (val != null) {
                          setState(() => item.source = val);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.black45),
                    onPressed: () => widget.controller.removeSplitRow(idx),
                  ),
                  const Spacer(),
                  const Text("Rs ", style: TextStyle(fontSize: 14, color: Colors.black87)),
                  SizedBox(
                    width: 85,
                    child: TextField(
                      controller: item.amountController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
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
                onTap: () => widget.controller.addSplitRow(banks),
                child: const Text("+ Add Payment Type",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
              Text("Received Rs ${widget.controller.totalReceivedAmount.toStringAsFixed(0)}",
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
                  controller: widget.controller.descriptionController,
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