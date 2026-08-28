import 'package:flutter/material.dart';

class DiscountWidget extends StatefulWidget {
  final List<String> categories; // 🎯 پیرنٹ ویجٹ سے categories حاصل کرنے کے لیے
  final Function(String categoryName, double discountValue, bool isPercentage) onDiscountChanged;

  const DiscountWidget({
    super.key,
    required this.categories, // 🎯 پیرامیٹر لازمی کر دیا گیا ہے
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

  @override
  Widget build(BuildContext context) {
    final List<String> catList = widget.categories.isEmpty ? ['Discounts'] : widget.categories;
    if (!catList.contains(_selectedCategory)) {
      _selectedCategory = catList.first;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
        children: [
          const Icon(
            Icons.local_offer_outlined,
            size: 18,
            color: Color(0xFFE53935),
          ),
          const SizedBox(width: 4),

          // 🎯 کیٹیگری ڈراپ ڈاؤن
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isDense: true,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black54, size: 20),
              items: catList.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
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
          const Spacer(),

          // 🎯 ٹوگل سوئچ (Rs / %)
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(
                  value: false,
                  label: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text('Rs', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
                ButtonSegment<bool>(
                  value: true,
                  label: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text('%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
              selected: {_isPercentage},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  _isPercentage = newSelection.first;
                  _updateDiscount();
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xFFE53935);
                  }
                  return Colors.transparent;
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) return Colors.white;
                  return Colors.black87;
                }),
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 🎯 ان پٹ باکس
          SizedBox(
            width: 90,
            height: 38,
            child: TextField(
              controller: _discountController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onChanged: (value) => _updateDiscount(),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
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
  }
}