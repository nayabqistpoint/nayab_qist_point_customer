import 'package:flutter/material.dart';

class PurchasePage extends StatelessWidget {
  const PurchasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text(
            'نیا موبائل و قسط پلان خریداری',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF0F172A),
          centerTitle: true,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'یہاں نیا موبائل پرچیز اور اقساطی پلانز کا ڈیزائن بنے گا...',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}