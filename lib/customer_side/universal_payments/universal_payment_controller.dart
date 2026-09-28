// lib/customer_side/universal_payments/universal_payment_controller.dart

import 'package:flutter/material.dart';
import 'universal_payment_services/payment_config_service.dart';
import 'universal_payment_services/payment_rebalance_engine.dart';

class UniversalPaymentController extends ChangeNotifier {
  final int baseAmount;
  final bool isInstallment;
  final String title;
  final String? itemName;
  final String? planTitle;
  final int? installmentNo;

  late final TextEditingController targetAmountCtrl;
  late final TextEditingController discountCtrl;
  final TextEditingController noteCtrl = TextEditingController();

  final List<TextEditingController> splitTextControllers = [];

  bool isCustomAmountMode = false;
  bool isLoadingConfig = true;

  bool hasReceiptPhoto = false;
  bool hasVoiceNote = false;
  bool isRecording = false;
  bool isPlayingAudio = false;

  List<String> availableSources = [];
  List<String> availableDiscountCategories = [];
  int selectedDiscountCategoryIndex = 0;

  final List<SplitSourceItem> splitEntries = [];

  UniversalPaymentController({
    required this.baseAmount,
    required this.isInstallment,
    required this.title,
    this.itemName,
    this.planTitle,
    this.installmentNo,
  }) {
    targetAmountCtrl = TextEditingController(text: baseAmount.toString());
    discountCtrl = TextEditingController(text: '0');

    targetAmountCtrl.addListener(_onTargetOrDiscountChanged);
    discountCtrl.addListener(_onTargetOrDiscountChanged);

    _initData();
  }

  Future<void> _initData() async {
    availableSources = await PaymentConfigService.getPaymentSources();
    availableDiscountCategories = await PaymentConfigService.getDiscountCategories();

    // جو سورس لسٹ میں پہلے نمبر پر ہے وہی بائی ڈیفالٹ مین سورس بنے گا
    final primarySource = availableSources.isNotEmpty ? availableSources.first : 'دکان کیش دراز';
    splitEntries.add(SplitSourceItem(source: primarySource, amount: baseAmount));

    final ctrl = TextEditingController(text: baseAmount.toString());
    splitTextControllers.add(ctrl);

    isLoadingConfig = false;
    notifyListeners();
  }

  @override
  void dispose() {
    targetAmountCtrl.dispose();
    discountCtrl.dispose();
    noteCtrl.dispose();
    for (final c in splitTextControllers) {
      c.dispose();
    }
    super.dispose();
  }

  int get targetPayable => int.tryParse(targetAmountCtrl.text.replaceAll(',', '').trim()) ?? 0;
  int get discountAmount => int.tryParse(discountCtrl.text.replaceAll(',', '').trim()) ?? 0;
  int get netRequiredCash => PaymentRebalanceEngine.calculateNetPayableAfterDiscount(
        totalTarget: targetPayable,
        discountAmount: discountAmount,
      );
  int get splitsSum => PaymentRebalanceEngine.calculateTotalSplits(splitEntries);
  int get discrepancy => PaymentRebalanceEngine.calculateDiscrepancy(
        totalTarget: targetPayable,
        splitsTotal: splitsSum,
        discountAmount: discountAmount,
      );
  bool get isReconciled => PaymentRebalanceEngine.verifyReconciliation(
        totalTarget: targetPayable,
        splitsTotal: splitsSum,
        discountAmount: discountAmount,
      );

  void refresh() => notifyListeners();

  /// پہلے مین سورس کی آٹو ایڈجسٹمنٹ
  void _syncPrimaryBox() {
    PaymentRebalanceEngine.autoAdjustPrimarySource(
      splits: splitEntries,
      totalTarget: targetPayable,
      discountAmount: discountAmount,
    );

    if (splitTextControllers.isNotEmpty && splitEntries.isNotEmpty) {
      final currentTxt = splitTextControllers[0].text;
      final newTxt = splitEntries[0].amount.toString();
      if (currentTxt != newTxt) {
        splitTextControllers[0].text = newTxt;
      }
    }
    notifyListeners();
  }

  void _onTargetOrDiscountChanged() {
    _syncPrimaryBox();
  }

  void toggleCustomMode(bool custom) {
    isCustomAmountMode = custom;
    targetAmountCtrl.text = baseAmount.toString();
    discountCtrl.text = '0';
    _syncPrimaryBox();
  }

  void setDiscountCategoryIndex(int index) {
    selectedDiscountCategoryIndex = index;
    notifyListeners();
  }

  /// جب کسی بھی سورس میں رقم لکھی جائے تو پہلے مین سورس سے خودبخود مائنس ہو
  void updateSplitAmount(int index, String val) {
    final parsed = int.tryParse(val.replaceAll(',', '').trim()) ?? 0;
    if (index >= 0 && index < splitEntries.length) {
      splitEntries[index].amount = parsed;

      // اگر ذیلی سورس (index > 0) میں تبدیلی ہوئی ہے تو پہلے مین سورس کو فوراً اپڈیٹ کریں
      if (index > 0) {
        _syncPrimaryBox();
      } else {
        notifyListeners();
      }
    }
  }

  void updateSplitSource(int index, String newSource) {
    if (index >= 0 && index < splitEntries.length) {
      splitEntries[index].source = newSource;
      notifyListeners();
    }
  }

  void addSplitEntry() {
    final defaultSource = availableSources.length > splitEntries.length
        ? availableSources[splitEntries.length]
        : (availableSources.isNotEmpty ? availableSources.last : 'بینک');

    splitEntries.add(SplitSourceItem(source: defaultSource, amount: 0));
    splitTextControllers.add(TextEditingController(text: '0'));
    _syncPrimaryBox();
  }

  void removeSplitEntry(int index) {
    if (splitEntries.length > 1 && index < splitEntries.length) {
      splitEntries.removeAt(index);
      splitTextControllers[index].dispose();
      splitTextControllers.removeAt(index);

      _syncPrimaryBox();
    }
  }

  void pickReceiptImage(dynamic source) {}
  void removeReceiptImage() {}
  void toggleVoiceRecord() {}
  void togglePlayVoice() {}
  void deleteVoiceNote() {}

  Map<String, dynamic> buildSubmissionResult() {
    return {
      'targetPayable': targetPayable,
      'paid': splitsSum,
      'discount': discountAmount,
      'extra': 0,
      'splits': splitEntries.map((e) => e.toMap()).toList(),
      'note': noteCtrl.text.trim(),
      'receiptImagePath': '',
      'voiceNotePath': '',
      'hasPhoto': hasReceiptPhoto,
      'hasAudio': hasVoiceNote,
    };
  }

  String formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}