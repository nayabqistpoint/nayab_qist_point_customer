import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LedgerItemData {
  final String key;
  final double amount;
  final double runningBalance;
  final String type;
  final String status;
  final bool isApproved;
  final DateTime date;
  final String description;
  final Color amountColor;

  const LedgerItemData({
    required this.key,
    required this.amount,
    required this.runningBalance,
    required this.type,
    required this.status,
    required this.isApproved,
    required this.date,
    required this.description,
    required this.amountColor,
  });
}

class LedgerListenerService {
  static ValueListenable<Box> getTransactionListenable() {
    return Hive.box('transactionBox').listenable();
  }

  static List<LedgerItemData> getProcessedTransactions({
    required Box box,
    required String customerPhone,
  }) {
    final String phone = customerPhone.trim();
    if (phone.isEmpty) return [];

    final List<Map<String, dynamic>> rawTxList = [];

    for (var k in box.keys) {
      final v = box.get(k);
      if (v is Map) {
        final Map<String, dynamic> tx = Map<String, dynamic>.from(v);
        final p = (tx['customerPhone'] ?? tx['customerId'] ?? '').toString().trim();
        if (p == phone) {
          tx['_k'] = k.toString();
          rawTxList.add(tx);
        }
      }
    }

    if (rawTxList.isEmpty) return [];

    rawTxList.sort((a, b) {
      final dtA = DateTime.tryParse((a['createdAt'] ?? a['timestamp'] ?? a['date'] ?? '').toString()) ?? DateTime(2000);
      final dtB = DateTime.tryParse((b['createdAt'] ?? b['timestamp'] ?? b['date'] ?? '').toString()) ?? DateTime(2000);
      final cmp = dtA.compareTo(dtB);
      return cmp != 0 ? cmp : a['_k'].toString().compareTo(b['_k'].toString());
    });

    double runningAcc = 0.0;
    final List<LedgerItemData> list = [];

    for (var tx in rawTxList) {
      final String status = (tx['status'] ?? '').toString().toLowerCase();
      final bool isApproved = (status == 'approved') || (status != 'pending' && tx['isApproved'] != false);

      final double amt = double.tryParse((tx['txAmount'] ?? tx['amount'] ?? tx['netAmount'] ?? 0).toString()) ?? 0.0;
      final String colorType = (tx['txColor'] ?? '').toString().toLowerCase();

      bool isCredit;
      if (colorType == 'green') {
        isCredit = true;
      } else if (colorType == 'red') {
        isCredit = false;
      } else {
        final String type = (tx['type'] ?? '').toString().toLowerCase();
        isCredit = (type == 'received' || type == 'pay_now');
      }

      if (isApproved) {
        if (isCredit) {
          runningAcc += amt.abs();
        } else {
          runningAcc -= amt.abs();
        }
      }

      final Color amountColor = !isApproved
          ? Colors.orange.shade800
          : (isCredit ? Colors.green.shade700 : Colors.red.shade700);

      final DateTime dt = DateTime.tryParse((tx['createdAt'] ?? tx['timestamp'] ?? tx['date'] ?? '').toString()) ?? DateTime.now();

      list.add(LedgerItemData(
        key: tx['_k'].toString(),
        amount: amt.abs(),
        runningBalance: runningAcc,
        type: (tx['type'] ?? '').toString(),
        status: status,
        isApproved: isApproved,
        date: dt,
        description: (tx['description'] ?? tx['note'] ?? tx['mobileName'] ?? 'تفصیل...').toString(),
        amountColor: amountColor,
      ));
    }

    return list.reversed.toList();
  }
}

/// 🎯 Ledger Top Helper Class
class BalanceHelper {
  static double calculateCustomerBalance(Box box, String customerPhone) {
    final list = LedgerListenerService.getProcessedTransactions(box: box, customerPhone: customerPhone);
    if (list.isEmpty) return 0.0;
    return list.first.runningBalance;
  }

  static Color getAmountColor(double balance) {
    if (balance > 0) return Colors.green.shade700;
    if (balance < 0) return Colors.red.shade700;
    return Colors.black87;
  }
}