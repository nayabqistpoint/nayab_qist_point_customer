// lib/customer_side/shop_showcase_portal/services/slots_feed_service.dart

class ShowcaseSlotItem {
  final String date;
  final String token;
  final String item;
  final String tag;
  final bool isAvailable;

  const ShowcaseSlotItem({
    required this.date,
    required this.token,
    required this.item,
    required this.tag,
    required this.isAvailable,
  });
}

class SlotsFeedService {
  static List<ShowcaseSlotItem> getLiveSlotsFeed(int availablePlansCount) {
    return [
      const ShowcaseSlotItem(
        date: '03 اکتوبر',
        token: '#NQP-401',
        item: 'Redmi 13C (128GB)',
        tag: 'کامیابی سے ڈلیور شدہ ✓',
        isAvailable: false,
      ),
      const ShowcaseSlotItem(
        date: '06 اکتوبر',
        token: '#NQP-EL-88',
        item: 'نیشنل جوسر بلینڈر 3in1',
        tag: '24 گھنٹے میں ترسیل مکمل ✓',
        isAvailable: false,
      ),
      const ShowcaseSlotItem(
        date: '08 اکتوبر',
        token: '#NQP-404',
        item: 'Infinix Hot 40 (256GB)',
        tag: 'ہینڈ اوور مکمل ✓',
        isAvailable: false,
      ),
      const ShowcaseSlotItem(
        date: '12 اکتوبر',
        token: '#NQP-408',
        item: 'Tecno Spark 20',
        tag: 'ضمانتی تصدیق جاری ⏳',
        isAvailable: false,
      ),
      ShowcaseSlotItem(
        date: '15 اکتوبر',
        token: 'سلاٹ نمبر 07',
        item: 'اسمارٹ فون (کوٹہ نشست خالی)',
        tag: 'دکان پر آ کر $availablePlansCount پلانز سے بک کریں 🟢',
        isAvailable: true,
      ),
      ShowcaseSlotItem(
        date: '18 اکتوبر',
        token: 'سلاٹ نمبر 08',
        item: 'اسمارٹ فون (کوٹہ نشست خالی)',
        tag: 'دکان پر آ کر $availablePlansCount پلانز سے بک کریں 🟢',
        isAvailable: true,
      ),
    ];
  }
}