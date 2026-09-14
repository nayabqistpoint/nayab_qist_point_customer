import 'package:flutter/material.dart';

class UniversalPaymentController {
  final int baseAmount;
  final bool isInstallment;
  final String title;

  late TextEditingController targetAmountCtrl;
  final TextEditingController noteCtrl = TextEditingController();
  final TextEditingController adjAmountCtrl = TextEditingController(text: '0');

  bool isPartial = false;
  bool hasPhoto = false;
  bool hasAudio = false;

  final List<String> configPaymentSources = [
    'دکان کیش دراز',
    'JazzCash (جاز کیش)',
    'EasyPaisa (ایزی پیسہ)',
    'Meezan Bank (میزان)',
    'Allied Bank (الائیڈ)',
  ];

  final List<Map<String, dynamic>> configAdjustmentCategories = [
    {'name': 'رعایت / ڈسکاؤنٹ (ڈائریکٹ ایکسپنس)', 'isIncome': false},
    {'name': 'گروسری / راشن خرچہ (ڈائریکٹ ایکسپنس)', 'isIncome': false},
    {'name': 'لیٹ فیس / اضافی وصولی (ادر انکم)', 'isIncome': true},
  ];

  late List<Map<String, dynamic>> splitEntries;
  int selectedAdjIndex = 0;

  UniversalPaymentController({
    required this.baseAmount,
    required this.isInstallment,
    required this.title,
  }) {
    targetAmountCtrl = TextEditingController(text: baseAmount.toString());
    splitEntries = [
      {'source': configPaymentSources.first, 'amount': baseAmount},
    ];
  }

  void dispose() {
    targetAmountCtrl.dispose();
    noteCtrl.dispose();
    adjAmountCtrl.dispose();
  }

  // حسابی فارمولے
  int get targetPayable => int.tryParse(targetAmountCtrl.text.replaceAll(',', '')) ?? 0;
  int get shortAmount => baseAmount - targetPayable;
  int get splitsSum => splitEntries.fold(0, (sum, item) => sum + ((item['amount'] as int?) ?? 0));
  int get adjVal => int.tryParse(adjAmountCtrl.text) ?? 0;
  bool get isIncome => configAdjustmentCategories[selectedAdjIndex]['isIncome'] as bool;
  int get requiredCashFromSources => isIncome ? (targetPayable + adjVal) : (targetPayable - adjVal);
  int get difference => splitsSum - requiredCashFromSources;
  bool get isReconciled => (difference == 0) && (splitsSum > 0 || adjVal > 0);

  // ایکشنز
  void togglePartial(bool partial) {
    isPartial = partial;
    int amt = partial ? (baseAmount / 2).toInt() : baseAmount;
    targetAmountCtrl.text = amt.toString();
    if (splitEntries.isNotEmpty) splitEntries[0]['amount'] = amt;
  }

  void updateTargetAmount(String val) {
    int p = int.tryParse(val) ?? 0;
    if (splitEntries.isNotEmpty) splitEntries[0]['amount'] = p;
  }

  void addSplitEntry() {
    splitEntries.add({'source': configPaymentSources.first, 'amount': 0});
  }

  void removeSplitEntry(int index) {
    if (splitEntries.length > 1) {
      splitEntries.removeAt(index);
    }
  }

  void updateSplitEntry(int index, String source, int amount) {
    splitEntries[index] = {'source': source, 'amount': amount};
  }

  Map<String, dynamic> buildSubmissionResult() {
    return {
      'resolved': targetPayable,
      'paid': splitsSum,
      'discount': isIncome ? 0 : adjVal,
      'extra': isIncome ? adjVal : 0,
      'splits': splitEntries,
      'note': noteCtrl.text,
      'hasPhoto': hasPhoto,
      'hasAudio': hasAudio,
    };
  }

  String formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}