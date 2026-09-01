import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/ledger/customer_ledger/ledger_listener_service.dart';

class LedgerRowViewModel {
  final String amountText;
  final String runningBalanceText;
  final String day;
  final String month;
  final String year;
  final String description;
  final bool isApproved;
  final Color amountColor;
  final Color runningBalanceColor; // 🎯 کیپسول کے رننگ بیلنس کا رنگ

  const LedgerRowViewModel({
    required this.amountText,
    required this.runningBalanceText,
    required this.day,
    required this.month,
    required this.year,
    required this.description,
    required this.isApproved,
    required this.amountColor,
    required this.runningBalanceColor,
  });
}

class MiddleRowLogic {
  static const List<String> _months = [
    "جنوری", "فروری", "مارچ", "اپریل", "مئی", "جون",
    "جولائی", "اگست", "ستمبر", "اکتوبر", "نومبر", "دسمبر"
  ];

  static List<LedgerRowViewModel> process({
    required Box box,
    required String customerPhone,
  }) {
    final rawList = LedgerListenerService.getProcessedTransactions(
      box: box,
      customerPhone: customerPhone,
    );

    return rawList.map((item) {
      final int monthIndex = item.date.month - 1;
      final String monthName = (monthIndex >= 0 && monthIndex < _months.length)
          ? _months[monthIndex]
          : "";

      final String runningBalanceStr = item.isApproved 
          ? item.runningBalance.abs().toStringAsFixed(0) 
          : "--";

      // 🎯 مجموعی رننگ بیلنس کی بنیاد پر کیپسول کے اندر کی رقم کا رنگ
      Color capsuleColor;
      if (!item.isApproved) {
        capsuleColor = Colors.grey.shade600;
      } else if (item.runningBalance > 0) {
        capsuleColor = Colors.green.shade700; // 🟢 تمام پچھلی روز کا مجموعہ اگر مثبت ہے
      } else if (item.runningBalance < 0) {
        capsuleColor = Colors.red.shade700;   // 🔴 تمام پچھلی روز کا مجموعہ اگر منفی ہے
      } else {
        capsuleColor = Colors.black87;        // ⚪ اگر بیلنس صفر (0) ہے
      }

      return LedgerRowViewModel(
        amountText: "Rs. ${item.amount.toStringAsFixed(0)}",
        runningBalanceText: runningBalanceStr,
        day: item.date.day.toString(),
        month: monthName,
        year: item.date.year.toString(),
        description: item.description,
        isApproved: item.isApproved,
        amountColor: item.amountColor,
        runningBalanceColor: capsuleColor, // 👈 کیپسول کے لیے نیا رنگ پاس کر دیا گیا
      );
    }).toList();
  }
}