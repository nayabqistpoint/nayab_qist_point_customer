class GroceryCatalogService {
  static final List<Map<String, dynamic>> defaultCatalog = [
    {'name': 'چینی پریمیم', 'unit': 'کلو', 'rate': 150},
    {'name': 'گھی کسان ڈالڈا (5 لیٹر)', 'unit': 'ٹین', 'rate': 2850},
    {'name': 'آٹا چکی خاص (20 کلو)', 'unit': 'تھیلا', 'rate': 2400},
    {'name': 'چاول باسمتی سپر کائنات', 'unit': 'کلو', 'rate': 320},
    {'name': 'دال چنا موٹی', 'unit': 'کلو', 'rate': 260},
    {'name': 'چائے پتی سپریم (900 گرام)', 'unit': 'پیکٹ', 'rate': 1650},
  ];

  static Iterable<Map<String, dynamic>> search(String query) {
    if (query.trim().isEmpty) return const [];
    return defaultCatalog.where(
      (e) => e['name'].toString().toLowerCase().contains(query.trim().toLowerCase()),
    );
  }
}