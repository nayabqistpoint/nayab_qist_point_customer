import 'package:flutter/material.dart';

class CustomEstimateSheetUi extends StatefulWidget {
  final Function(String name, int estimatePrice, int advance) onSubmit;

  const CustomEstimateSheetUi({super.key, required this.onSubmit});

  @override
  State<CustomEstimateSheetUi> createState() => _CustomEstimateSheetUiState();
}

class _CustomEstimateSheetUiState extends State<CustomEstimateSheetUi> {
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

  void _validateAndSubmit() {
    final price = int.tryParse(_priceCtrl.text.trim()) ?? 0;
    final adv = int.tryParse(_advanceCtrl.text.trim()) ?? 0;

    if (price <= 0) {
      setState(() => _error = 'برائے مہربانی درست مالیت درج کریں');
      return;
    }
    if (adv > 0 && adv < 5000) {
      setState(() => _error = 'ایڈوانس یا تو 0 ہونا چاہیے یا کم از کم Rs. 5,000');
      return;
    }

    widget.onSubmit(_nameCtrl.text.trim(), price, adv);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'اپنی مرضی کے موبائل کا تخمینہ',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 4),
              const Text(
                'موبائل کا نام اور مطلوبہ مالیت درج کریں:',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: 'موبائل ماڈل کا نام (اختیاری)',
                  hintText: 'مثلاً Oppo A78 یا Vivo Y200',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _priceCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'مارکیٹ مالیت کا اندازہ (تخمینہ رقم)*',
                  hintText: 'مثلاً 50000',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _advanceCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'متوقع ایڈوانس رقم (بغیر ایڈوانس کے لیے 0 لکھیں)',
                  hintText: '0 یا کم از کم 5000',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 6),
                Text(
                  _error!,
                  style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
                ),
              ],
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validateAndSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('28 اقساطی پیکجز کا شیڈول دیکھیں', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}