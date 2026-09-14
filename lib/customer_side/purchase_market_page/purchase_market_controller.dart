import 'package:flutter/material.dart';

class PurchaseMarketController extends ChangeNotifier {
  int expandedCardIndex = -1;

  final List<Map<String, dynamic>> stockItems = [
    {
      'id': 'STK-901',
      'name': 'Infinix Note 40 Pro',
      'baseValue': 75000,
      'ramRom': '8GB / 256GB',
      'condition': 'ڈبہ پیک',
      'status': 'موجود ہے',
      'zeroAdvMonthly': 7812,
      'minMonthlyWithAdv': 6250,
      'minAdvance': 10000,
      'images': [
        'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=800',
        'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=800',
      ],
    },
    {
      'id': 'STK-902',
      'name': 'Vivo Y21 Ultra',
      'baseValue': 48000,
      'ramRom': '4GB / 64GB',
      'condition': 'استعمال شدہ (10/10)',
      'status': 'موجود ہے',
      'zeroAdvMonthly': 5000,
      'minMonthlyWithAdv': 4000,
      'minAdvance': 6000,
      'images': [
        'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=800',
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
      ],
    },
    {
      'id': 'STK-903',
      'name': 'Tecno Camon 30',
      'baseValue': 58000,
      'ramRom': '8GB / 128GB',
      'condition': 'ڈبہ پیک',
      'status': 'آرڈر پر دستیاب',
      'zeroAdvMonthly': 6040,
      'minMonthlyWithAdv': 4830,
      'minAdvance': 8000,
      'images': [
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
        'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=800',
      ],
    },
  ];

  void toggleRibbon(int index) {
    if (expandedCardIndex == index) {
      expandedCardIndex = -1;
    } else {
      expandedCardIndex = index;
    }
    notifyListeners();
  }
}