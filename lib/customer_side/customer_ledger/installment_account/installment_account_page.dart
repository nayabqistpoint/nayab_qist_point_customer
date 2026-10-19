import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'installment_args.dart';
import 'installment_controller.dart';
import 'components/installment_view_body_ui.dart';

class InstallmentAccountPage extends StatefulWidget {
  final InstallmentArgs args;

  const InstallmentAccountPage({super.key, required this.args});

  @override
  State<InstallmentAccountPage> createState() => _InstallmentAccountPageState();
}

class _InstallmentAccountPageState extends State<InstallmentAccountPage> {
  late final InstallmentController controller;

  @override
  void initState() {
    super.initState();
    controller = InstallmentController(args: widget.args);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onPayInstallment(Map<String, dynamic> item) {
    final prod = controller.currentProduct;
    final int remaining = (item['remainingAmount'] as int?) ?? (item['amount'] as int? ?? 0);
    final int totalRemaining = (prod['remaining'] as int?) ?? remaining;

    // 🎯 کراس فیچر بائی پاس ختم: صرف نامزد روٹ اور را آرگومنٹس کے ذریعے کال
    Navigator.pushNamed(
      context,
      '/universal_payment',
      arguments: {
        'title': 'قسط نمبر ${item['no']} کی ادائیگی',
        'baseAmount': remaining,
        'isInstallment': true,
        'itemName': prod['name']?.toString() ?? 'موبائل فون',
        'planTitle': prod['plan']?.toString() ?? 'اقساط پلان',
        'installmentNo': item['no'],
        'maxAllowedAmount': totalRemaining,
        'customerPhone': widget.args.customerPhone,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listenable = controller.boxListenable;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF0F172A),
          title: const Text(
            'اقساط کھاتہ تفصیلات',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: listenable == null
            ? AnimatedBuilder(
                animation: controller,
                builder: (_, __) => InstallmentViewBodyUi(
                  controller: controller,
                  onPaymentRequested: _onPayInstallment,
                ),
              )
            : ValueListenableBuilder<Box>(
                valueListenable: listenable,
                builder: (_, __, ___) {
                  controller.loadInstallmentData();
                  return AnimatedBuilder(
                    animation: controller,
                    builder: (_, __) => InstallmentViewBodyUi(
                      controller: controller,
                      onPaymentRequested: _onPayInstallment,
                    ),
                  );
                },
              ),
      ),
    );
  }
}