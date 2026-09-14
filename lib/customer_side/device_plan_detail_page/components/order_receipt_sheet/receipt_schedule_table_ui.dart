import 'package:flutter/material.dart';

class ReceiptScheduleTableUi extends StatelessWidget {
  final List<Map<String, dynamic>> installmentSchedule;

  const ReceiptScheduleTableUi({super.key, required this.installmentSchedule});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'ماہانہ قسط شیڈول (ہر ماہ کی 5 تاریخ):',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ),
              SizedBox(width: 6),
              Text(
                'واجب الادا',
                style: TextStyle(fontSize: 10, color: Color(0xFF0D9488), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 12, color: Color(0xFFCBD5E1)),
          ...installmentSchedule.map((row) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.5),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${row['no']}',
                    style: const TextStyle(fontSize: 9.5, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'قسط ${row['no']} (${row['dueDate']})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Rs. ${row['amount']}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}