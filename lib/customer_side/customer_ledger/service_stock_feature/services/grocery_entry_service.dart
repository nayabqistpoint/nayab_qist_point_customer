import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_feature/services/grocery_price_history_service.dart';

class GroceryEntryService {
  final priceHistoryService = GroceryPriceHistoryService();

  final itemNameCtrl = TextEditingController();
  final itemPriceCtrl = TextEditingController(text: '0');
  int currentQty = 1;
  int currentPrice = 0;

  List<Map<String, dynamic>> groceryList = [];

  int get groceryTotal => groceryList.fold(0, (sum, i) => sum + (i['amount'] as int));

  void selectAutocompleteItem(String selection) {
    itemNameCtrl.text = selection;
    final lastPrice = priceHistoryService.getLastPrice(selection);
    currentPrice = lastPrice;
    itemPriceCtrl.text = lastPrice.toString();
  }

  void incrementQty() => currentQty++;
  void decrementQty() {
    if (currentQty > 1) currentQty--;
  }

  void incrementPrice() {
    currentPrice++;
    itemPriceCtrl.text = currentPrice.toString();
  }

  void decrementPrice() {
    if (currentPrice > 0) {
      currentPrice--;
      itemPriceCtrl.text = currentPrice.toString();
    }
  }

  void setManualPrice(String text) {
    currentPrice = int.tryParse(text) ?? 0;
  }

  bool addGroceryItem() {
    final name = itemNameCtrl.text.trim();
    final price = int.tryParse(itemPriceCtrl.text.trim().replaceAll(',', '')) ?? currentPrice;

    if (name.isNotEmpty && price > 0) {
      groceryList.add({
        'name': name,
        'qty': currentQty,
        'amount': price * currentQty,
        'unitPrice': price,
      });
      priceHistoryService.recordPrice(name, price);

      itemNameCtrl.clear();
      currentQty = 1;
      currentPrice = 0;
      itemPriceCtrl.text = '0';
      return true;
    }
    return false;
  }

  void removeGroceryItem(int index) {
    groceryList.removeAt(index);
  }

  void dispose() {
    itemNameCtrl.dispose();
    itemPriceCtrl.dispose();
  }
}