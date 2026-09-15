import 'package:flutter/material.dart';

class GroceryExpenseService {
  final itemNameCtrl = TextEditingController();
  final itemAmountCtrl = TextEditingController();

  List<Map<String, dynamic>> groceryList = [
    {'name': 'چینی (5 کلو)', 'amount': 750},
  ];

  final List<String> configExpenseCategories = [
    'گھریلو راشن و گروسری (ڈائریکٹ ایکسپنس)',
    'دکان چائے پانی / اخراجات (ان ڈائریکٹ ایکسپنس)',
    'رعایت / خصوصی ڈسکاؤنٹ (ڈائریکٹ ایکسپنس)',
    'دکان مرمت و سروس ورکشاپ (ان ڈائریکٹ ایکسپنس)',
    'دیگر متفرق اخراجات (General Expense)',
  ];

  List<Map<String, dynamic>> expenseAllocations = [
    {'category': 'گھریلو راشن و گروسری (ڈائریکٹ ایکسپنس)', 'amount': 750},
  ];

  int get totalBill => groceryList.fold(0, (sum, i) => sum + (i['amount'] as int));

  int get expenseSum =>
      expenseAllocations.fold(0, (sum, e) => sum + ((e['amount'] as int?) ?? 0));

  int get expenseDifference => expenseSum - totalBill;

  bool get isExpenseReconciled => (expenseDifference == 0 && totalBill > 0);

  void syncExpenseWithTotal() {
    if (expenseAllocations.isNotEmpty) {
      expenseAllocations[0]['amount'] = totalBill;
    }
  }

  void addGroceryItem() {
    if (itemNameCtrl.text.isNotEmpty && itemAmountCtrl.text.isNotEmpty) {
      groceryList.add({
        'name': itemNameCtrl.text.trim(),
        'amount': int.tryParse(itemAmountCtrl.text.trim().replaceAll(',', '')) ?? 0,
      });
      itemNameCtrl.clear();
      itemAmountCtrl.clear();
      syncExpenseWithTotal();
    }
  }

  void removeGroceryItem(int index) {
    groceryList.removeAt(index);
    syncExpenseWithTotal();
  }

  void addExpenseAllocation() {
    expenseAllocations.add({
      'category': configExpenseCategories[1],
      'amount': 0,
    });
  }

  void updateExpenseCategory(int index, String category) {
    expenseAllocations[index]['category'] = category;
  }

  void updateExpenseAmount(int index, String amountStr) {
    expenseAllocations[index]['amount'] = int.tryParse(amountStr) ?? 0;
  }

  void removeExpenseAllocation(int index) {
    expenseAllocations.removeAt(index);
  }

  void dispose() {
    itemNameCtrl.dispose();
    itemAmountCtrl.dispose();
  }
}