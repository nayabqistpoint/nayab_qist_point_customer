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

  LedgerRowViewModel({
    required this.amountText,
    required this.runningBalanceText,
    required this.day,
    required this.month,
    required this.year,
    required this.description,
    required this.isApproved,
    required this.amountColor,
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
      String mName = (item.date.month >= 1 && item.date.month <= 12)
          ? _months[item.date.month - 1]
          : "";

      return LedgerRowViewModel(
        amountText: "Rs. ${item.amount.toStringAsFixed(0)}",
        runningBalanceText: item.isApproved ? item.runningBalance.abs().toStringAsFixed(0) : "--",
        day: item.date.day.toString(),
        month: mName,
        year: item.date.year.toString(),
        description: item.description,
        isApproved: item.isApproved,
        amountColor: item.amountColor,
      );
    }).toList();
  }
}