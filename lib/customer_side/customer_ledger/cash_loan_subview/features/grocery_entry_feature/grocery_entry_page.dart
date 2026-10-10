import 'package:flutter/material.dart';
import 'grocery_entry_controller.dart';
import 'components/grocery_item_input_card_ui.dart';
import 'components/grocery_items_table_ui.dart';
import 'components/grocery_media_toggles_ui.dart';
import '../../../../payload_services/grocery_entry_payload_service.dart';

class GroceryEntryPage extends StatefulWidget {
  final String customerPhone;
  const GroceryEntryPage({super.key, required this.customerPhone});

  @override
  State<GroceryEntryPage> createState() => _GroceryEntryPageState();
}

class _GroceryEntryPageState extends State<GroceryEntryPage> {
  late final GroceryEntryController controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    controller = GroceryEntryController(customerPhone: widget.customerPhone);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (controller.items.isEmpty) return;
    setState(() => _isSaving = true);
    await GroceryEntryPayloadService.saveGroceryEntry(
      customerPhone: widget.customerPhone,
      grandTotal: controller.grandTotal,
      items: controller.items,
      hasPhoto: controller.hasPhoto,
      hasAudio: controller.hasAudio,
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
            title: const Text('راشن بل اندراج', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            backgroundColor: const Color(0xFF0F766E),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GroceryItemInputCardUi(controller: controller, onAdd: controller.addItem),
                const SizedBox(height: 16),
                GroceryItemsTableUi(items: controller.items),
                const SizedBox(height: 16),
                GroceryMediaTogglesUi(
                  hasPhoto: controller.hasPhoto,
                  hasAudio: controller.hasAudio,
                  onPhotoChanged: controller.togglePhoto,
                  onAudioChanged: controller.toggleAudio,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _submit,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('محفوظ کریں: Rs. ${controller.grandTotal}', style: const TextStyle(fontWeight: FontWeight.bold)),
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