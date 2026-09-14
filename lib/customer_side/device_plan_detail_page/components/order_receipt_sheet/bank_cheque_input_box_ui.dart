import 'package:flutter/material.dart';

class BankChequeInputBoxUi extends StatelessWidget {
  final TextEditingController bankNameCtrl;
  final TextEditingController chequeNoCtrl;

  const BankChequeInputBoxUi({
    super.key,
    required this.bankNameCtrl,
    required this.chequeNoCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  size: 15,
                  color: Color(0xFF047857),
                ),
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'بینک چیک کی ضروری تفصیلات (لازمی):',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF047857),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: bankNameCtrl,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'بینک کا نام (مثلاً HBL, Meezan, UBL)*',
              labelStyle: const TextStyle(fontSize: 11),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: chequeNoCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'چیک نمبر (Cheque No)*',
              labelStyle: const TextStyle(fontSize: 11),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}