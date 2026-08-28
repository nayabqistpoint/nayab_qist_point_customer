import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomerLedgerController extends ChangeNotifier {
  final String customerPhone;

  bool isLoading = true;
  Map<String, dynamic>? customerDetails;
  List<Map<String, dynamic>> transactions = [];

  CustomerLedgerController({required this.customerPhone}) {
    loadLedgerData();
  }

  Future<void> loadLedgerData() async {
    isLoading = true;
    notifyListeners();

    try {
      final customerBox = Hive.box('customerBox');
      final usersBox = Hive.box('usersBox');

      dynamic rawCustomer = customerBox.get(customerPhone) ?? usersBox.get(customerPhone);

      if (rawCustomer != null) {
        customerDetails = Map<String, dynamic>.from(rawCustomer as Map);
      } else {
        customerDetails = {
          'phone': customerPhone,
          'customerName': 'کسٹمر ($customerPhone)',
        };
      }

      final transactionBox = Hive.box('transactionBox');
      transactions.clear();

      for (var key in transactionBox.keys) {
        final rawTx = transactionBox.get(key);
        if (rawTx != null) {
          final txMap = Map<String, dynamic>.from(rawTx as Map);
          if (txMap['customerPhone'] == customerPhone || txMap['phone'] == customerPhone) {
            transactions.add(txMap);
          }
        }
      }

      transactions.sort((a, b) {
        String dateA = a['date'] ?? '';
        String dateB = b['date'] ?? '';
        return dateB.compareTo(dateA);
      });
    } catch (e) {
      debugPrint('❌ [LedgerController Error] $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🎯 🚀 مطلوبہ میتھڈ جو top.dart میں کال ہو رہا ہے:
  void openInstallmentCalculator(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('قسط کیلکولیٹر', textAlign: TextAlign.center),
        content: const Text('اقساط کا کیلکولیٹر جلد دستیاب ہوگا۔', textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('بند کریں'),
          ),
        ],
      ),
    );
  }

  double get totalAmount {
    return transactions.fold(0.0, (sum, item) {
      return sum + (double.tryParse(item['totalAmount']?.toString() ?? '0') ?? 0.0);
    });
  }

  double get totalPaid {
    return transactions.fold(0.0, (sum, item) {
      return sum + (double.tryParse(item['paidAmount']?.toString() ?? '0') ?? 0.0);
    });
  }

  double get remainingBalance => totalAmount - totalPaid;
}