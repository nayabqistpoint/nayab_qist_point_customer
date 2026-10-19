import 'package:flutter/material.dart';
import 'universal_payment_args.dart';
import 'services/payment_config_service.dart';
import 'services/payment_math_service.dart';
import 'services/payment_rebalance_engine.dart';
import 'services/payment_storage_handler.dart';

class UniversalPaymentController extends ChangeNotifier {
  final UniversalPaymentArgs args;

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

  UniversalPaymentController({required this.args}) {
    targetAmountCtrl = TextEditingController(text: args.baseAmount.toString());
    discountCtrl = TextEditingController(text: '0');
    targetAmountCtrl.addListener(_syncCalculations);
    discountCtrl.addListener(_syncCalculations);
    _initData();
  }

  int get baseAmount => args.baseAmount;
  bool get isInstallment => args.isInstallment;
  String get title => args.title;
  String? get itemName => args.itemName;
  String? get planTitle => args.planTitle;
  int? get maxAllowedAmount => args.maxAllowedAmount;

  int get targetPayable => int.tryParse(targetAmountCtrl.text.replaceAll(',', '').trim()) ?? 0;
  int get discountAmount => int.tryParse(discountCtrl.text.replaceAll(',', '').trim()) ?? 0;
  int get splitsSum => PaymentRebalanceEngine.calculateTotalSplits(splitEntries);
  int get discrepancy => PaymentRebalanceEngine.calculateDiscrepancy(
        totalTarget: targetPayable,
        splitsTotal: splitsSum,
        discountAmount: discountAmount,
      );

  bool get isExceedingMaxLimit =>
      isInstallment && maxAllowedAmount != null && maxAllowedAmount! > 0 && targetPayable > maxAllowedAmount!;

  bool get isReconciled =>
      !isExceedingMaxLimit &&
      PaymentRebalanceEngine.verifyReconciliation(
        totalTarget: targetPayable,
        splitsTotal: splitsSum,
        discountAmount: discountAmount,
      );

  Future<void> _initData() async {
    availableSources = await PaymentConfigService.getPaymentSources();
    availableDiscountCategories = await PaymentConfigService.getDiscountCategories();

    final primary = availableSources.isNotEmpty ? availableSources.first : 'دکان کیش دراز';
    splitEntries.add(SplitSourceItem(source: primary, amount: baseAmount));
    splitTextControllers.add(TextEditingController(text: baseAmount.toString()));

    isLoadingConfig = false;
    notifyListeners();
  }

  void _syncCalculations() {
    PaymentRebalanceEngine.autoAdjustPrimarySource(
      splits: splitEntries,
      controllers: splitTextControllers,
      totalTarget: targetPayable,
      discountAmount: discountAmount,
    );
    notifyListeners();
  }

  void toggleCustomMode(bool custom) {
    isCustomAmountMode = custom;
    targetAmountCtrl.text = baseAmount.toString();
    discountCtrl.text = '0';
    _syncCalculations();
  }

  void setDiscountCategoryIndex(int index) {
    selectedDiscountCategoryIndex = index;
    notifyListeners();
  }

  void updateSplitAmount(int index, String val) {
    final parsed = int.tryParse(val.replaceAll(',', '').trim()) ?? 0;
    if (index >= 0 && index < splitEntries.length) {
      splitEntries[index].amount = parsed;
      if (index > 0) {
        _syncCalculations();
      } else {
        notifyListeners();
      }
    }
  }

  void updateSplitSource(int index, String source) {
    if (index >= 0 && index < splitEntries.length) {
      splitEntries[index].source = source;
      notifyListeners();
    }
  }

  void addSplitEntry() {
    final nextSource = availableSources.length > splitEntries.length
        ? availableSources[splitEntries.length]
        : (availableSources.isNotEmpty ? availableSources.last : 'بینک');

    splitEntries.add(SplitSourceItem(source: nextSource, amount: 0));
    splitTextControllers.add(TextEditingController(text: '0'));
    _syncCalculations();
  }

  void removeSplitEntry(int index) {
    if (splitEntries.length > 1 && index < splitEntries.length) {
      splitEntries.removeAt(index);
      splitTextControllers[index].dispose();
      splitTextControllers.removeAt(index);
      _syncCalculations();
    }
  }

  void pickReceiptImage(dynamic source) {}
  void removeReceiptImage() {}
  void toggleVoiceRecord() {}
  void togglePlayVoice() {}
  void deleteVoiceNote() {}

  Map<String, dynamic> buildSubmissionResult() {
    return PaymentStorageHandler.generateSubmissionPayload(
      targetPayable: targetPayable,
      splitsSum: splitsSum,
      discountAmount: discountAmount,
      splits: splitEntries.map((e) => e.toMap()).toList(),
      note: noteCtrl.text.trim(),
      receiptImagePath: '',
      voiceNotePath: '',
      hasPhoto: hasReceiptPhoto,
      hasAudio: hasVoiceNote,
    );
  }

  String formatAmount(int amount) => PaymentMathService.formatAmount(amount);

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
}