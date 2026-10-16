import 'package:flutter/material.dart';
import 'stock_entry_controller.dart';
import 'components/stock_mode_toggle_card_ui.dart';
import 'components/stock_category_selector_ui.dart';
import 'components/stock_specifications_card_ui.dart';
import 'components/stock_general_fields_ui.dart';
import 'components/stock_pricing_card_ui.dart';
import 'components/stock_multi_image_card_ui.dart';

class StockEntryPage extends StatefulWidget {
  final String customerPhone;
  const StockEntryPage({super.key, required this.customerPhone});

  @override
  State<StockEntryPage> createState() => _StockEntryPageState();
}

class _StockEntryPageState extends State<StockEntryPage> {
  late final StockEntryController controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    controller = StockEntryController(customerPhone: widget.customerPhone);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSaving = true);
    final success = await controller.submitEntry();
    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('براہ کرم تمام لازمی فیلڈز درست درج کریں'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: const Text(
              'اسٹاک انٹری (موبائل و جنرل اشیاء)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF1E40AF),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ۱. پروموشنل / دکان کا مال ٹوگل
                StockModeToggleCardUi(
                  isPromotionalOnOrder: controller.isPromotionalOnOrder,
                  onToggle: controller.toggleMode,
                ),
                const SizedBox(height: 16),

                // ۲. کیٹیگری سلیکٹر (موبائل بمقابلہ دیگر سامان)
                StockCategorySelectorUi(controller: controller),
                const SizedBox(height: 16),

                // ۳. متحرک فیلڈز (موبائل کے لیے ماڈل/اسپیکس یا دیگر سامان کے لیے جنرل تفصیل)
                if (controller.isMobile)
                  StockSpecificationsCardUi(controller: controller)
                else
                  StockGeneralFieldsUi(controller: controller),

                const SizedBox(height: 16),

                // ۴. خریداری اور سیل قیمت کارڈ
                StockPricingCardUi(controller: controller),
                const SizedBox(height: 16),

                // ۵. تصاویر کا کارڈ
                StockMultiImageCardUi(
                  images: controller.images,
                  onAddImage: () => controller.addMockImage('https://via.placeholder.com/150'),
                  onRemoveImage: (String path) => controller.removeImageByPath(path),
                ),
                const SizedBox(height: 20),

                // ۶. سیو بٹن
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      foregroundColor: Colors.white,
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'اسٹاک محفوظ کریں',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}