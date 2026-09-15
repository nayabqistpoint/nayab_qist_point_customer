import 'package:flutter/material.dart';

class EstimateSheetFormUi extends StatefulWidget {
  final Function(String name, int estimatePrice, int advance) onSubmit;

  const EstimateSheetFormUi({super.key, required this.onSubmit});

  @override
  State<EstimateSheetFormUi> createState() => _EstimateSheetFormUiState();
}

class _EstimateSheetFormUiState extends State<EstimateSheetFormUi> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _advanceCtrl = TextEditingController(text: '0');
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _advanceCtrl.dispose();
    super.dispose();
  }

  void _validate() {
    final price = int.tryParse(_priceCtrl.text.trim()) ?? 0;
    final adv = int.tryParse(_advanceCtrl.text.trim()) ?? 0;

    if (price <= 0) {
      setState(() => _error = 'برائے مہربانی درست مالیت درج کریں');
      return;
    }
    if (adv > 0 && adv < 5000) {
      setState(() => _error = 'ایڈوانس یا تو 0 ہو یا کم از کم Rs. 5,000');
      return;
    }

    // 🚀 صرف ڈیٹا آگے بھیجیں (Navigator.pop یہاں نہیں لگانا)
    widget.onSubmit(_nameCtrl.text.trim(), price, adv);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _field(_nameCtrl, 'موبائل ماڈل کا نام (اختیاری)', 'مثلاً Vivo Y200، ریڈمی', TextInputType.text),
          const SizedBox(height: 12),
          _field(_priceCtrl, 'کل مالیت کا تخمینہ (روپوں میں)*', 'مثلاً 45000', TextInputType.number),
          const SizedBox(height: 12),
          _field(_advanceCtrl, 'متوقع ایڈوانس رقم (بغیر ایڈوانس کیلئے 0 رکھیں)', '0 یا کم از کم 5000', TextInputType.number),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626), fontWeight: FontWeight.bold)),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _validate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text('28 اقساطی پیکجز کا شیڈول دیکھیں', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, String hint, TextInputType type) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
        isDense: true,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.3)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      ),
    );
  }
}