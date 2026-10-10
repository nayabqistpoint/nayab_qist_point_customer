import 'package:flutter/material.dart';
import 'stock_entry_controller.dart';
import 'components/stock_mode_toggle_card_ui.dart';
import 'components/stock_specifications_card_ui.dart';
import 'components/stock_pricing_card_ui.dart';
import 'components/stock_multi_image_card_ui.dart';
import '../../../../payload_services/stock_entry_payload_service.dart';

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
    final model = controller.modelCtrl.text.trim();
    final purchase = int.tryParse(controller.purchasePriceCtrl.text.trim()) ?? 0;
    final sale = double.tryParse(controller.salePriceCtrl.text.trim()) ?? 0.0;
    if (model.isEmpty || sale <= 0) return;

    setState(() => _isSaving = true);
    await StockEntryPayloadService.saveStockEntry(
      customerPhone: widget.customerPhone,
      model: model,
      ramRom: controller.selectedRamRom,
      color: controller.selectedColor,
      conditionType: controller.selectedConditionType,
      conditionRating: controller.selectedConditionRating,
      imeiNo: controller.imeiCtrl.text.trim(),
      warranty: controller.selectedWarranty,
      purchasePrice: purchase,
      salePrice: sale,
      isPromotionalOnOrder: controller.isPromotionalOnOrder,
      images: controller.images,
    );
    if (mounted) Navigator.pop(context);
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
            title: const Text('سپلائر موبائل اسٹاک انٹری', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            backgroundColor: const Color(0xFF1E40AF),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                StockModeToggleCardUi(isPromotionalOnOrder: controller.isPromotionalOnOrder, onToggle: controller.toggleMode),
                const SizedBox(height: 16),
                StockSpecificationsCardUi(controller: controller),
                const SizedBox(height: 16),
                StockPricingCardUi(controller: controller),
                const SizedBox(height: 16),
                StockMultiImageCardUi(images: controller.images, onAddImage: controller.addMockImage, onRemoveImage: controller.removeImage),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _submit,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E40AF), foregroundColor: Colors.white),
                    child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('اسٹاک محفوظ کریں', style: TextStyle(fontWeight: FontWeight.bold)),
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