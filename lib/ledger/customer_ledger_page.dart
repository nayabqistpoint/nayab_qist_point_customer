import 'package:flutter/material.dart';

// 🎯 تمام امپورٹس بالکل وہی ہیں جو آپ کی اصل فائل میں تھیں
import 'package:nayab_qist_point_customer/ledger/customer_ledger/customer_ledger_controller.dart';
import 'package:nayab_qist_point_customer/ledger/customer_ledger/top.dart';
import 'package:nayab_qist_point_customer/ledger/customer_ledger/middle_row_ui.dart';
import 'package:nayab_qist_point_customer/ledger/customer_ledger/bottom.dart';

class CustomerLedgerPage extends StatefulWidget {
  final String? customerPhone;

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
      customerPhone: widget.customerPhone ?? '',
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
          body: SafeArea(
            child: Column(
              children: [
                // ۱۔ اوپر کا حصہ (ایپ بار، کارڈز اور قسط کیلکولیٹر - یہ اوپر ساکن رہے گا)
                LedgerTopWidget(controller: _controller),

                // ۲۔ درمیانی لسٹ (صرف یہی درمیانی لسٹ اسکرول ہوگی)
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: MiddleRowUi(controller: _controller),
                  ),
                ),

                // ۳۔ نچلا حصہ (بٹن - یہ نیچے ساکن رہیں گے)
                LedgerBottomWidget(controller: _controller),
              ],
            ),
          ),
        );
      },
    );
  }
}