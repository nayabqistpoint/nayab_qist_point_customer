import 'package:flutter/material.dart';

class GroceryItemsTableUi extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const GroceryItemsTableUi({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Center(
          child: Text('ابھی تک کوئی آئٹم شامل نہیں کی گئی', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Table(
        border: TableBorder.all(color: const Color(0xFFCBD5E1)),
        columnWidths: const {0: FlexColumnWidth(2.4), 1: FlexColumnWidth(1.2), 2: FlexColumnWidth(1.2), 3: FlexColumnWidth(1.4)},
        children: [
          const TableRow(
            decoration: BoxDecoration(color: Color(0xFFF0FDFA)),
            children: [
              Padding(padding: EdgeInsets.all(8), child: Text('آئٹم', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              Padding(padding: EdgeInsets.all(8), child: Text('مقدار', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              Padding(padding: EdgeInsets.all(8), child: Text('ریٹ', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              Padding(padding: EdgeInsets.all(8), child: Text('ٹوٹل', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
            ],
          ),
          ...items.map((itm) => TableRow(
            children: [
              Padding(padding: const EdgeInsets.all(8), child: Text(itm['name'], style: const TextStyle(fontSize: 11.5))),
              Padding(padding: const EdgeInsets.all(8), child: Text(itm['qty'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 11.5))),
              Padding(padding: const EdgeInsets.all(8), child: Text('Rs. ${itm['rate']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11))),
              Padding(padding: const EdgeInsets.all(8), child: Text('Rs. ${itm['amount']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)))),
            ],
          )),
        ],
      ),
    );
  }
}