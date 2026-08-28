import 'package:flutter/material.dart';

import 'package:nayab_qist_point_customer/ledger/customer_ledger/customer_ledger_controller.dart';
import 'package:nayab_qist_point_customer/ledger/customer_ledger/ledger_bottom_helper.dart';

class LedgerBottomWidget extends StatelessWidget {
  final CustomerLedgerController controller;

  const LedgerBottomWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          _btn(
            "خریداری کی درخواست",
            Colors.orange.shade800,
            () => LedgerBottomHelper.handleLeftButton(context, controller),
          ),
          const SizedBox(width: 15),
          _btn(
            "قسط ادا کریں",
            Colors.blue.shade800,
            () => LedgerBottomHelper.handleRightButton(context, controller),
          ),
        ],
      ),
    );
  }

  Widget _btn(String label, Color color, VoidCallback onTap) => Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: const StadiumBorder(),
          ),
          onPressed: onTap,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      );
}