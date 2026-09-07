import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DiscountWidget extends StatefulWidget {
  final Function(String categoryName, double discountValue, bool isPercentage) onDiscountChanged;

  const DiscountWidget({
    super.key,
    required this.onDiscountChanged,
  });

  @override
  State<DiscountWidget> createState() => _DiscountWidgetState();
}

class _DiscountWidgetState extends State<DiscountWidget> {
  final TextEditingController _discountController = TextEditingController();
  bool _isPercentage = false;
  String _selectedCategory = 'Discounts';

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  void _updateDiscount() {
    final value = double.tryParse(_discountController.text) ?? 0.0;
    widget.onDiscountChanged(_selectedCategory, value, _isPercentage);
  }

  /// 🟢 Hive Box سے ڈسکاؤنٹ کیٹیگریز ایکسٹریکٹ کرنے کا فنکشن
  List<String> _getDiscountCategories(Box box) {
    List<String> categories = ['Discounts'];
    final docData = box.get('discounts_config');
    if (docData is Map) {
      final mapData = Map<String, dynamic>.from(docData);
      if (mapData['discountCategories'] is Map) {
        final innerMap = Map<String, dynamic>.from(mapData['discountCategories'] as Map);
        final extractedKeys = innerMap.keys.map((e) => e.toString()).toList();
        if (extractedKeys.isNotEmpty) {
          categories = extractedKeys;
        }
      }
    }
    if (!categories.contains('Discounts')) {
      categories.insert(0, 'Discounts');
    }
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('appConfigBox').listenable(),
      builder: (context, Box box, _) {
        final List<String> catList = _getDiscountCategories(box);
        if (!catList.contains(_selectedCategory)) {
          _selectedCategory = catList.first;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🎯 ۱۔ ڈراپ ڈاؤن پورشن (جو اب فالتو فاصلہ نہیں چھوڑے گا)
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_offer_outlined,
                      size: 18,
                      color: Color(0xFFE53935),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isDense: true,
                          isExpanded: false, // پورے اسکرین پر پھیلنے سے روکا گیا
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE53935),
                          ),
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.black54, size: 20),
                          items: catList.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(
                                category,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE53935),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedCategory = newValue;
                                _updateDiscount();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // 🎯 ۲۔ متوازن، واضع اور خوبصورت (Rs / %) کیپسول
              Container(
                height: 34,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCapsuleOption(
                      label: 'Rs',
                      isSelected: !_isPercentage,
                      onTap: () {
                        if (_isPercentage) {
                          setState(() {
                            _isPercentage = false;
                            _updateDiscount();
                          });
                        }
                      },
                    ),
                    _buildCapsuleOption(
                      label: '%',
                      isSelected: _isPercentage,
                      onTap: () {
                        if (!_isPercentage) {
                          setState(() {
                            _isPercentage = true;
                            _updateDiscount();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // 🎯 ۳۔ رقم کا ٹیکسٹ فیلڈ (مناسب سائز)
              SizedBox(
                width: 70,
                height: 34,
                child: TextField(
                  controller: _discountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  onChanged: (value) => _updateDiscount(),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        color: Color(0xFFE53935),
                        width: 1.5,
                      ),
                    ),
                  ),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCapsuleOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE53935) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFE53935).withValues(alpha: 0.25),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}