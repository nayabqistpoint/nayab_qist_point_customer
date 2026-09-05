import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:nayab_qist_point_customer/calculator/calculator_controller.dart'; 
import 'package:nayab_qist_point_customer/calculator/app_config_service.dart';
import 'package:nayab_qist_point_customer/calculator/available_stock_selector.dart';

class CalculaterHeaderUi extends StatefulWidget {
  final Function(Map<String, dynamic>)? onDataChanged;

  const CalculaterHeaderUi({super.key, this.onDataChanged});

  @override
  State<CalculaterHeaderUi> createState() => _CalculaterHeaderUiState();
}

class _CalculaterHeaderUiState extends State<CalculaterHeaderUi> {
  int _selectedMode = 2; // 🟢 بائی ڈیفالٹ: اپنی مرضی (مینول)
  String? _selectedStockMobileName;

  final TextEditingController _manualModelController = TextEditingController();
  final TextEditingController _advanceController = TextEditingController();
  final TextEditingController _imeiController = TextEditingController();
  final TextEditingController _manualTotalController = TextEditingController();
  final TextEditingController _checkNumberController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();

  void _notifyDataChanged(CalculaterController controller) {
    if (widget.onDataChanged != null) {
      String mobileName = _selectedMode == 1 
          ? (_selectedStockMobileName ?? '') 
          : _manualModelController.text;

      widget.onDataChanged!({
        'mobileName': mobileName,
        'cashPrice': controller.totalAmount.toStringAsFixed(0),
        'advanceAmount': _advanceController.text,
        'imei': _imeiController.text,
        'totalAmount': controller.totalAmount.toStringAsFixed(0),
        'checkNumber': _checkNumberController.text,
        'bankName': _bankNameController.text,
        'isBuyStockMode': _selectedMode == 1,
      });
    }
  }

  /// 🟢 باٹم شیٹ شو کرنے کا فنکشن
  Future<void> _openStockSelector(CalculaterController controller) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AvailableStockSelectorWidget(),
    );

    if (result != null) {
      setState(() {
        _selectedStockMobileName = result['mobileName'] ?? '';
        _imeiController.text = result['imeiNo'] ?? '';
        controller.setTotalAmount(result['salePrice'] ?? '0');
        _notifyDataChanged(controller);
      });
    }
  }

  @override
  void dispose() {
    _manualModelController.dispose();
    _advanceController.dispose();
    _imeiController.dispose();
    _manualTotalController.dispose();
    _checkNumberController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CalculaterController>(context);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            color: const Color(0xFFE53935),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("قسط کیلکولیٹر", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                Text("نایاب قسط پوائنٹ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<int>(
                    segments: const [
                      ButtonSegment<int>(value: 1, label: Text("دستیاب سٹاک سے", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                      ButtonSegment<int>(value: 2, label: Text("اپنی مرضی (مینول)", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                    ],
                    selected: {_selectedMode},
                    onSelectionChanged: (Set<int> newSelection) {
                      setState(() {
                        _selectedMode = newSelection.first;
                        _selectedStockMobileName = null;
                        _manualModelController.clear();
                        _manualTotalController.clear();
                        _advanceController.clear();
                        _imeiController.clear();
                        controller.setTotalAmount("0");
                        controller.setAdvanceAmount("0");
                        _notifyDataChanged(controller);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // موڈ ۱: دستیاب اسٹاک باٹم شیٹ کلک فیلڈ
                if (_selectedMode == 1) ...[
                  InkWell(
                    onTap: () => _openStockSelector(controller),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedStockMobileName ?? "دستیاب سٹاک سے منتخب کریں...",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: _selectedStockMobileName != null ? FontWeight.bold : FontWeight.normal,
                              color: _selectedStockMobileName != null ? Colors.black87 : Colors.grey.shade600,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  
                  if (_selectedStockMobileName != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_advanceController, "ایڈوانس", TextInputType.number, (v) {
                          controller.setAdvanceAmount(v);
                          _notifyDataChanged(controller);
                        })),
                        const SizedBox(width: 6),
                        Expanded(child: _buildTextField(_imeiController, "IMEI نمبر", TextInputType.text, null, readOnly: true)),
                      ],
                    ),
                  ],
                ],

                // موڈ ۲: اپنی مرضی (مینول) ان پٹ (بائی ڈیفالٹ)
                if (_selectedMode == 2) ...[
                  _buildTextField(_manualModelController, "موبائل کا نام اور ماڈل لکھیں", TextInputType.text, (v) {
                    setState(() {});
                    _notifyDataChanged(controller);
                  }),
                  
                  if (_manualModelController.text.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_manualTotalController, "نقد قیمت", TextInputType.number, (v) {
                          controller.setTotalAmount(v);
                          _notifyDataChanged(controller);
                        })),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField(_advanceController, "ایڈوانس", TextInputType.number, (v) {
                          controller.setAdvanceAmount(v);
                          _notifyDataChanged(controller);
                        })),
                      ],
                    ),
                  ],
                ],
                
                Consumer<CalculaterController>(
                  builder: (context, controller, child) {
                    final message = controller.getValidationMessage();
                    if (message == null) return const SizedBox.shrink(); 
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(message, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    );
                  },
                ),
                
                const SizedBox(height: 10),
                
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: controller.hasSecurityCheck,
                            activeColor: Colors.blue,
                            onChanged: (bool? value) {
                              controller.toggleSecurityCheck(value ?? false);
                              _notifyDataChanged(controller);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "رعایت حاصل کرنے کے لیے سیکیورٹی چیک مہیا کریں",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                if (controller.hasSecurityCheck) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(_checkNumberController, "چیک نمبر", TextInputType.text, (v) => _notifyDataChanged(controller))),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(_bankNameController, "بینک کا نام", TextInputType.text, (v) => _notifyDataChanged(controller))),
                    ],
                  ),
                ],

                const SizedBox(height: 10),

                InkWell(
                  onTap: () async {
                    final Uri launchUri = Uri(scheme: 'tel', path: AppConfigService.contactNumber);
                    await launchUrl(launchUri);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "رابطہ: ${AppConfigService.contactName} - ${AppConfigService.contactNumber}",
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16, decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, TextInputType type, Function(String)? onChange, {bool readOnly = false}) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: ctrl,
        readOnly: readOnly,
        textAlign: TextAlign.center,
        keyboardType: type,
        onChanged: onChange,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}