import 'package:flutter/material.dart';

// 🎯 تصویر کے سٹرکچر کے مطابق بالکل درست امپورٹ پاتھس:
import 'package:nayab_qist_point_customer/ledger/customer_ledger/customer_ledger_controller.dart';
import 'package:nayab_qist_point_customer/ledger/customer_ledger/top.dart';
import 'package:nayab_qist_point_customer/ledger/customer_ledger/middle.dart';
import 'package:nayab_qist_point_customer/ledger/customer_ledger/bottom.dart';

class CustomerLedgerPage extends StatefulWidget {
  final String? customerPhone; // 🎯 کسٹمر کا موبائل نمبر بطور پرائمری آئی ڈی

  const CustomerLedgerPage({
    super.key,
    this.customerPhone,
  });

  @override
  State<CustomerLedgerPage> createState() => _CustomerLedgerPageState();
}

class _CustomerLedgerPageState extends State<CustomerLedgerPage> {
  late final CustomerLedgerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CustomerLedgerController(
      customerPhone: widget.customerPhone ?? '', // 🎯 صرف موبائل نمبر بطور سنگل سورس پاس ہو رہا ہے
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      LedgerTopWidget(controller: _controller),
                      LedgerMiddleWidget(controller: _controller),
                    ],
                  ),
                ),
              ),
              LedgerBottomWidget(controller: _controller),
            ],
          ),
        );
      },
    );
  }
}