class GroceryPriceHistoryService {
  final Map<String, int> _itemHistoryPriceMap = {
    'چینی': 150,
    'گھی ڈالڈا': 550,
    'دال چنا': 260,
    'آٹا (10 کلو)': 1100,
    'چاول باسمتی': 320,
    'کوکنگ آئل': 580,
    'صابن لکس': 115,
    'پتی لپٹن': 340,
  };

  Iterable<String> searchItems(String query) {
    if (query.isEmpty) return const Iterable<String>.empty();
    return _itemHistoryPriceMap.keys.where((item) => item.contains(query));
  }

  int getLastPrice(String itemName) {
    return _itemHistoryPriceMap[itemName] ?? 0;
  }

  void recordPrice(String itemName, int price) {
    if (itemName.isNotEmpty && price > 0) {
      _itemHistoryPriceMap[itemName] = price;
    }
  }
}