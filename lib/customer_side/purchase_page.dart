import 'package:flutter/material.dart';

class PurchasePage extends StatefulWidget {
  // اگر بندہ لاگ ان ہے تو فون نمبر پاس ہوگا، ورنہ null (پبلک ریڈ اونلی موڈ)
  final String? customerPhone;

  const PurchasePage({super.key, this.customerPhone});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  int _activeViewIndex = 0; // 0 = کسٹمر مارکیٹ، 1 = تفصیلی ویو
  int _expandedCardIndex = -1; // ان لائن فوری ربن

  // فلٹرز برائے 28 اقساطی پلانز
  int _selectedDuration = 0; // 0 = تمام مدتیں
  String _selectedGuaranteeFilter = 'ALL'; // ALL, BANK_CHEQUE, LEGAL_STAMP
  String _selectedAdvanceFilter = 'ALL'; // ALL, WITH_ADV, ZERO_ADV

  // دستی ایڈوانس فیلڈ
  int _userCustomAdvance = 0;
  final TextEditingController _customAdvanceFilterCtrl = TextEditingController();

  // منتخب موبائل کا تفصیلی ڈیٹا
  final Map<String, dynamic> _selectedDevice = {
    'name': 'Redmi Note 13 (8/256)',
    'baseValue': 62000,
    'tag': 'اسٹاک میں موجود',
    'ramRom': '8GB / 256GB',
    'condition': 'ڈبہ پیک (Pin Pack)',
    'warranty': '12 ماہ آفیشل وارنٹی',
    'minAdvanceRequired': 8000,
    'images': [
      'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=800',
      'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
      'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=800',
    ],
  };

  // اسٹاک لسٹ
  final List<Map<String, dynamic>> _stockItems = [
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

  @override
  void dispose() {
    _customAdvanceFilterCtrl.dispose();
    super.dispose();
  }

  // 🗓️ 5 تاریخ اور 15 دن گریس پیریڈ کا حسابی جنریٹر
  List<Map<String, dynamic>> _generateInstallmentSchedule(int months, int monthlyAmount) {
    final List<Map<String, dynamic>> schedule = [];
    final DateTime now = DateTime.now();

    // ہر ماہ کی 5 تاریخ کا حساب
    DateTime nextFifth = DateTime(now.year, now.month, 5);
    if (nextFifth.isBefore(now)) {
      nextFifth = DateTime(now.year, now.month + 1, 5);
    }

    // اگر آنے والی 5 تاریخ تک کا فاصلہ 15 دن سے کم ہے تو اگلا مہینہ گریس پیریڈ بنے گا
    final int daysLeft = nextFifth.difference(now).inDays;
    DateTime firstDueDate = nextFifth;
    if (daysLeft < 15) {
      firstDueDate = DateTime(nextFifth.year, nextFifth.month + 1, 5);
    }

    final urduMonths = [
      '', 'جنوری', 'فروری', 'مارچ', 'اپریل', 'مئی', 'جون',
      'جولائی', 'اگست', 'ستمبر', 'اکتوبر', 'نومبر', 'دسمبر'
    ];

    for (int i = 0; i < months; i++) {
      final DateTime installmentDate = DateTime(firstDueDate.year, firstDueDate.month + i, 5);
      final String formattedDate = '05 ${urduMonths[installmentDate.month]} ${installmentDate.year}';

      schedule.add({
        'no': i + 1,
        'dueDate': formattedDate,
        'amount': monthlyAmount,
        'status': 'DUE',
      });
    }

    return schedule;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: _buildLuxuryAppBar(),
        body: _activeViewIndex == 0 ? _buildMarketStockView() : _buildPlanDetailsView(),
      ),
    );
  }

  PreferredSizeWidget _buildLuxuryAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF0F172A),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
        onPressed: () {
          if (_activeViewIndex == 1) {
            setState(() => _activeViewIndex = 0);
          } else {
            Navigator.pop(context);
          }
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _activeViewIndex == 0 ? 'موبائل اقساط مارکیٹ' : _selectedDevice['name'],
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 2),
          Text(
            widget.customerPhone == null
                ? 'پبلک ریٹ ویور • 28 سمارٹ اقساطی پلانز'
                : 'کھاتہ: ${widget.customerPhone} • تصدیق شدہ کسٹمر',
            style: const TextStyle(fontSize: 10.5, color: Color(0xFFFDE68A), fontWeight: FontWeight.w700),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'دستی تخمینہ',
          icon: const Icon(Icons.calculate_outlined, color: Color(0xFF34D399)),
          onPressed: () => _openSmartCalculatorSheet(),
        ),
      ],
    );
  }

  Widget _buildMarketStockView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLuminousGradientBanner(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'دکان پر دستیاب موبائل فونز',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(6)),
                child: Text(
                  '${_stockItems.length} ماڈلز موجود',
                  style: const TextStyle(fontSize: 10.5, color: Color(0xFF475569), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...List.generate(_stockItems.length, (idx) => _buildProductCardWithRibbon(_stockItems[idx], idx)),
        ],
      ),
    );
  }

  Widget _buildLuminousGradientBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          center: Alignment(-0.8, -0.6),
          radius: 1.4,
          colors: [
            Color(0xFF334155),
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF475569).withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF34D399).withValues(alpha: 0.4)),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF34D399), size: 19),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'اپنی پسند کے موبائل کا قسط پلان بنائیں',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'اگر آپ کا مطلوبہ ماڈل لسٹ میں شامل نہیں، تو نیچے بٹن دبا کر فوری اپنے بجٹ کے مطابق اقساط نکالیں:',
            style: TextStyle(fontSize: 11, color: Color(0xFFFDE68A), height: 1.4, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _openSmartCalculatorSheet(),
            icon: const Icon(Icons.touch_app_rounded, size: 15),
            label: const Text('دستی قیمت کا حساب لگائیں (Custom Estimate)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              foregroundColor: Colors.white,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCardWithRibbon(Map<String, dynamic> item, int index) {
    final bool isRibbonOpen = _expandedCardIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isRibbonOpen ? const Color(0xFF0D9488) : const Color(0xFFCBD5E1),
          width: isRibbonOpen ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              setState(() {
                _selectedDevice['name'] = item['name'];
                _selectedDevice['baseValue'] = item['baseValue'];
                _selectedDevice['ramRom'] = item['ramRom'];
                _selectedDevice['condition'] = item['condition'];
                _selectedDevice['images'] = item['images'];
                _selectedDevice['minAdvanceRequired'] = item['minAdvance'];
                _userCustomAdvance = item['minAdvance'];
                _customAdvanceFilterCtrl.text = _userCustomAdvance.toString();
                _activeViewIndex = 1;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 88,
                      height: 94,
                      color: const Color(0xFFF8FAFC),
                      child: Image.network(
                        (item['images'] as List).first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.phone_android_rounded, size: 38, color: Color(0xFF94A3B8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                item['status'],
                                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${item['ramRom']} • ${item['condition']}',
                          style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: const Color(0xFFA7F3D0)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.stars_rounded, size: 13, color: Color(0xFF059669)),
                              const SizedBox(width: 4),
                              Text(
                                'بغیر ایڈوانس: Rs. ${item['zeroAdvMonthly']} /ماہ',
                                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: Color(0xFF065F46)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'یا ایڈوانس کے ساتھ صرف: Rs. ${item['minMonthlyWithAdv']} /ماہ',
                          style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          InkWell(
            onTap: () => setState(() => _expandedCardIndex = isRibbonOpen ? -1 : index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isRibbonOpen ? const Color(0xFFF0FDFA) : const Color(0xFFF8FAFC),
                border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(13), bottomRight: Radius.circular(13)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        isRibbonOpen ? Icons.keyboard_double_arrow_up_rounded : Icons.table_chart_outlined,
                        size: 14,
                        color: const Color(0xFF0D9488),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isRibbonOpen ? 'فوری موازنہ بند کریں' : 'سب سے سستے 6 ماہ کے 2 پلانز دیکھیں',
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                      ),
                    ],
                  ),
                  Icon(
                    isRibbonOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (isRibbonOpen) ...[
            Container(
              padding: const EdgeInsets.all(10),
              color: const Color(0xFFF8FAFC),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _miniRateBadge('6 ماہ (بغیر ایڈوانس)', item['zeroAdvMonthly'], isGreen: true),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _miniRateBadge('6 ماہ (ایڈوانس کے ساتھ)', item['minMonthlyWithAdv'], isGreen: false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedDevice['name'] = item['name'];
                          _selectedDevice['baseValue'] = item['baseValue'];
                          _selectedDevice['ramRom'] = item['ramRom'];
                          _selectedDevice['condition'] = item['condition'];
                          _selectedDevice['images'] = item['images'];
                          _selectedDevice['minAdvanceRequired'] = item['minAdvance'];
                          _userCustomAdvance = item['minAdvance'];
                          _customAdvanceFilterCtrl.text = _userCustomAdvance.toString();
                          _activeViewIndex = 1;
                        });
                      },
                      icon: const Icon(Icons.fullscreen_rounded, size: 15),
                      label: const Text('مکمل 28 اقساطی پلانز کھولیں اور آرڈر بک کریں'),
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        foregroundColor: const Color(0xFF0F172A),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _miniRateBadge(String title, int monthly, {required bool isGreen}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isGreen ? const Color(0xFFECFDF5) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isGreen ? const Color(0xFFA7F3D0) : const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 9.5, color: isGreen ? const Color(0xFF065F46) : const Color(0xFF64748B), fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text('Rs. $monthly /ماہ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: isGreen ? const Color(0xFF059669) : const Color(0xFF0D9488))),
        ],
      ),
    );
  }

  Widget _buildPlanDetailsView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailHeroCard(),
          const SizedBox(height: 14),
          _buildPromotional28Banner(),
          const SizedBox(height: 10),
          _buildFilterAndAdvanceToolbar(),
          const SizedBox(height: 12),
          _buildScheduleTableSection(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildPromotional28Banner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFDE68A).withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFFDE68A),
              shape: BoxShape.circle,
            ),
            child: const Text(
              '28',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نایاب 28 اقساطی پیکجز کا مکمل جدول',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: Color(0xFFFDE68A)),
                ),
                SizedBox(height: 1),
                Text(
                  '7 مدتیں (6 تا 12 ماہ) • 14 چیک مع 14 اشٹام پلانز • زیرو ایڈوانس سہولت',
                  style: TextStyle(fontSize: 9.5, color: Colors.white70, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailHeroCard() {
    final List imgList = (_selectedDevice['images'] as List?) ?? [];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 180,
                child: PageView.builder(
                  itemCount: imgList.isNotEmpty ? imgList.length : 1,
                  itemBuilder: (ctx, i) {
                    final String url = imgList.isNotEmpty ? imgList[i] : '';
                    return InkWell(
                      onTap: () => _openFullScreenImageGallery(i, imgList.cast<String>()),
                      child: Container(
                        color: const Color(0xFFF8FAFC),
                        child: Image.network(
                          url,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.phone_android_rounded, size: 70, color: Color(0xFF0D9488)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 8,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    children: [
                      Icon(Icons.zoom_in_rounded, size: 12, color: Colors.white),
                      SizedBox(width: 4),
                      Text('بڑی تصویر دیکھنے کے لیے ٹیپ کریں', style: TextStyle(color: Colors.white, fontSize: 9.5)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDevice['name'],
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(6)),
                      child: const Text(
                        'صرف آسان اقساط پر دستیاب',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _badgeChip(Icons.memory_rounded, _selectedDevice['ramRom']),
                    _badgeChip(Icons.verified_rounded, _selectedDevice['condition']),
                    _badgeChip(Icons.security_rounded, _selectedDevice['warranty'] ?? '12 ماہ آفیشل وارنٹی'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openFullScreenImageGallery(int initialIndex, List<String> images) {
    int curIdx = initialIndex;
    final PageController pageController = PageController(initialPage: initialIndex);

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.95),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
                  onPressed: () => Navigator.pop(ctx),
                ),
                title: Text(
                  'تصویر ${curIdx + 1} از ${images.length}',
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: images.length,
                      onPageChanged: (idx) {
                        setDialogState(() => curIdx = idx);
                      },
                      itemBuilder: (context, i) {
                        return InteractiveViewer(
                          panEnabled: true,
                          minScale: 0.8,
                          maxScale: 4.0,
                          child: Center(
                            child: Image.network(
                              images[i],
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_rounded, color: Colors.white, size: 80),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (images.length > 1)
                    Container(
                      height: 70,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(images.length, (i) {
                          final bool isSel = curIdx == i;
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() => curIdx = i);
                              pageController.animateToPage(
                                i,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: isSel ? const Color(0xFF34D399) : Colors.transparent, width: 2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(images[i], fit: BoxFit.cover),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _badgeChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF475569)),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
        ],
      ),
    );
  }

  Widget _buildFilterAndAdvanceToolbar() {
    final int minAdv = (_selectedDevice['minAdvanceRequired'] as int?) ?? 5000;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ضمانت اور مدت چھانٹیں (تمام فلٹرز آن ہونے پر 28 پیکجز نظر آئیں گے):',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('سبھی ضمانتیں (28)', _selectedGuaranteeFilter == 'ALL', () => setState(() => _selectedGuaranteeFilter = 'ALL')),
                _filterChip('🏦 بینک چیک گارنٹی (14)', _selectedGuaranteeFilter == 'BANK_CHEQUE', () => setState(() => _selectedGuaranteeFilter = 'BANK_CHEQUE')),
                _filterChip('⚖️ قانونی اشٹام و پرنوٹ (14)', _selectedGuaranteeFilter == 'LEGAL_STAMP', () => setState(() => _selectedGuaranteeFilter = 'LEGAL_STAMP')),
              ],
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('تمام آپشنز', _selectedAdvanceFilter == 'ALL', () => setState(() => _selectedAdvanceFilter = 'ALL')),
                _filterChip('⭐ بغیر ایڈوانس (14)', _selectedAdvanceFilter == 'ZERO_ADV', () => setState(() => _selectedAdvanceFilter = 'ZERO_ADV')),
                _filterChip('👛 ایڈوانس کے ساتھ (14)', _selectedAdvanceFilter == 'WITH_ADV', () => setState(() => _selectedAdvanceFilter = 'WITH_ADV')),
              ],
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('تمام 7 مدتیں', _selectedDuration == 0, () => setState(() => _selectedDuration = 0)),
                _filterChip('6 ماہ', _selectedDuration == 6, () => setState(() => _selectedDuration = 6)),
                _filterChip('7 ماہ', _selectedDuration == 7, () => setState(() => _selectedDuration = 7)),
                _filterChip('8 ماہ', _selectedDuration == 8, () => setState(() => _selectedDuration = 8)),
                _filterChip('9 ماہ', _selectedDuration == 9, () => setState(() => _selectedDuration = 9)),
                _filterChip('10 ماہ', _selectedDuration == 10, () => setState(() => _selectedDuration = 10)),
                _filterChip('11 ماہ', _selectedDuration == 11, () => setState(() => _selectedDuration = 11)),
                _filterChip('12 ماہ', _selectedDuration == 12, () => setState(() => _selectedDuration = 12)),
              ],
            ),
          ),
          const Divider(height: 16, color: Color(0xFFE2E8F0)),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ایڈوانس رقم تبدیل کریں (قسط کم کرنے کے لیے):',
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'کم از کم ضروری ایڈوانس: Rs. $minAdv',
                      style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 120,
                height: 38,
                child: TextField(
                  controller: _customAdvanceFilterCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: 'Rs. ',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: (val) {
                    final int v = int.tryParse(val.trim()) ?? 0;
                    setState(() => _userCustomAdvance = v);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String text, bool active, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: active ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1)),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: active ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleTableSection() {
    final int base = _selectedDevice['baseValue'] as int;
    final int minAdv = (_selectedDevice['minAdvanceRequired'] as int?) ?? 5000;
    final int effectiveAdvance = _userCustomAdvance > 0 ? _userCustomAdvance : minAdv;

    final List<int> durations = [6, 7, 8, 9, 10, 11, 12];
    List<Map<String, dynamic>> allPlans = [];

    for (var m in durations) {
      final totalWithProfitCheque = (base * 1.25).toInt();
      final adv1 = effectiveAdvance;
      final monthly1 = ((totalWithProfitCheque - adv1) / m).toInt();

      allPlans.add({
        'months': m,
        'guarantee': 'BANK_CHEQUE',
        'hasAdvance': true,
        'advance': adv1,
        'monthly': monthly1,
        'title': 'بینک چیک پلان (مع ایڈوانس)',
      });

      allPlans.add({
        'months': m,
        'guarantee': 'BANK_CHEQUE',
        'hasAdvance': false,
        'advance': 0,
        'monthly': (totalWithProfitCheque / m).toInt(),
        'title': 'بینک چیک پلان (بغیر ایڈوانس)',
      });

      final totalWithProfitStamp = (base * 1.35).toInt();
      final adv2 = effectiveAdvance;
      final monthly2 = ((totalWithProfitStamp - adv2) / m).toInt();

      allPlans.add({
        'months': m,
        'guarantee': 'LEGAL_STAMP',
        'hasAdvance': true,
        'advance': adv2,
        'monthly': monthly2,
        'title': 'اشٹام پرنوٹ پلان (مع ایڈوانس)',
      });

      allPlans.add({
        'months': m,
        'guarantee': 'LEGAL_STAMP',
        'hasAdvance': false,
        'advance': 0,
        'monthly': (totalWithProfitStamp / m).toInt(),
        'title': 'اشٹام پرنوٹ پلان (بغیر ایڈوانس)',
      });
    }

    final filtered = allPlans.where((p) {
      if (_selectedGuaranteeFilter != 'ALL' && p['guarantee'] != _selectedGuaranteeFilter) return false;
      if (_selectedAdvanceFilter == 'WITH_ADV' && !p['hasAdvance']) return false;
      if (_selectedAdvanceFilter == 'ZERO_ADV' && p['hasAdvance']) return false;
      if (_selectedDuration != 0 && p['months'] != _selectedDuration) return false;
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'اقساطی پلانز کا شیڈول جدول:',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: const Color(0xFF0D9488).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
              child: Text(
                '${filtered.length} پیکجز ظاہر ہیں',
                style: const TextStyle(fontSize: 11, color: Color(0xFF0D9488), fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...filtered.map((plan) => _buildBillPlanRow(plan)),
      ],
    );
  }

  Widget _buildBillPlanRow(Map<String, dynamic> plan) {
    final bool isCheque = plan['guarantee'] == 'BANK_CHEQUE';
    final bool hasAdv = plan['hasAdvance'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCheque ? const Color(0xFFA7F3D0) : const Color(0xFFC7D2FE),
          width: 1.3,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: isCheque ? const Color(0xFFECFDF5) : const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isCheque ? const Color(0xFFA7F3D0) : const Color(0xFFC7D2FE),
                  ),
                ),
                child: Icon(
                  isCheque ? Icons.account_balance_rounded : Icons.balance_rounded,
                  size: 20,
                  color: isCheque ? const Color(0xFF059669) : const Color(0xFF3730A3),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${plan['months']} ماہ کی مدت',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: isCheque ? const Color(0xFFDCFCE7) : const Color(0xFFE0E7FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isCheque ? 'بینک چیک گارنٹی' : 'اشٹام پرنوٹ ضمانت',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: isCheque ? const Color(0xFF047857) : const Color(0xFF3730A3),
                          ),
                        ),
                      ),
                      const Text(' • ', style: TextStyle(color: Color(0xFFCBD5E1))),
                      Text(
                        hasAdv ? 'ایڈوانس: Rs. ${plan['advance']}' : '⭐ بغیر ایڈوانس (0 Adv)',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: hasAdv ? const Color(0xFFB45309) : const Color(0xFF059669),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rs. ${plan['monthly']}',
                style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: Color(0xFF0D9488)),
              ),
              const Text('ماہانہ قسط', style: TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8))),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: () => _openDigitalSlipReceiptSheet(plan),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text('آرڈر شیڈول', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🧾 باضابطہ آرڈر رسید سلپ مع مکمل 5 تاریخ کا اقساطی شیڈول اور بینک چیک انٹری
  void _openDigitalSlipReceiptSheet(Map<String, dynamic> plan) {
    final int advance = plan['advance'] as int;
    final int monthly = plan['monthly'] as int;
    final int months = plan['months'] as int;
    final int totalInstallmentSum = advance + (monthly * months);
    final String tokenNo = 'NQP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final bool isChequePlan = plan['guarantee'] == 'BANK_CHEQUE';

    // 5 تاریخ والا خودکار شیڈول
    final List<Map<String, dynamic>> installmentSchedule = _generateInstallmentSchedule(months, monthly);

    final bankNameCtrl = TextEditingController();
    final chequeNoCtrl = TextEditingController();
    String? localError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setReceiptState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(ctx).size.height * 0.90, // زیادہ اسکرین کوریج برائے ٹیبل
                ),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, -4)),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Center(
                        child: Opacity(
                          opacity: 0.03,
                          child: Text(
                            'نایاب قسط پوائنٹ\nOFFICIAL SCHEDULE',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.red[900]),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(width: 36, height: 4, decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(10))),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('نایاب قسط پوائنٹ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                                  Text('رسید ٹوکن: $tokenNo', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.hourglass_top_rounded, size: 11, color: Color(0xFFFDE68A)),
                                    SizedBox(width: 4),
                                    Text(
                                      'زیرِ جائزہ (Pending)',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFFDE68A)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: List.generate(
                              30,
                              (i) => Expanded(
                                child: Container(
                                  color: i.isEven ? const Color(0xFFCBD5E1) : Colors.transparent,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          _slipRow('مطلوبہ موبائل ماڈل:', _selectedDevice['name'].toString()),
                          _slipRow('ضمانت کی قسم:', isChequePlan ? 'بینک چیک گارنٹی' : 'اشٹام پرنوٹ ضمانت'),
                          _slipRow('اقساط کی کل مدت:', '$months ماہ'),
                          _slipRow('طے شدہ ایڈوانس رقم:', advance > 0 ? 'Rs. $advance' : '⭐ بغیر ایڈوانس (Zero Advance)'),
                          _slipRow('مقررہ ماہانہ قسط:', 'Rs. $monthly / ماہ', isHighlight: true),
                          const Divider(color: Color(0xFFE2E8F0)),
                          _slipRow('کل اقساط معاہدہ رقم:', 'Rs. $totalInstallmentSum', isBold: true),

                          const SizedBox(height: 12),

                          // 📅 مکمل اقساط پلان ٹیبل (ہر ماہ کی 5 تاریخ مع گریس پیریڈ لاجک)
                          Container(
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ماہانہ تاریخ وار قسط شیڈول (ہر ماہ کی 5 تاریخ):',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                    ),
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 22,
                                            height: 22,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF0F172A),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              '${row['no']}',
                                              style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'قسط نمبر ${row['no']} (${row['dueDate']})',
                                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Rs. ${row['amount']}',
                                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // 🏦 اگر چیک کا انتخاب ہے تو بینک کی معلومات لازمی ہوں گی
                          if (isChequePlan) ...[
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFA7F3D0)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.account_balance_rounded, size: 16, color: Color(0xFF047857)),
                                      SizedBox(width: 6),
                                      Text(
                                        'بینک چیک کی ضروری تفصیلات (لازمی):',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF047857)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: bankNameCtrl,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: 'بینک کا نام (مثلاً HBL, Meezan, UBL)*',
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
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],

                          if (localError != null) ...[
                            Text(
                              localError!,
                              style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                          ],

                          // گریس پیریڈ کا وضاحتی نوٹ
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                            child: const Text(
                              'نوٹ: اگر تاریخ درخواست سے آنے والی 5 تاریخ میں 15 دن سے کم وقفہ ہو تو پہلی قسط اگلے ماہ کی 5 تاریخ سے شروع ہو گی۔',
                              style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B), height: 1.3),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // 🚀 آرڈر ارسال کریں بٹن (مع لاگ ان بیریئر چیک)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // 1️⃣ بینک فیلڈز چیک
                                if (isChequePlan) {
                                  if (bankNameCtrl.text.trim().isEmpty || chequeNoCtrl.text.trim().isEmpty) {
                                    setReceiptState(() => localError = 'برائے مہربانی بینک کا نام اور چیک نمبر درج کریں!');
                                    return;
                                  }
                                }

                                // 2️⃣ لاگ ان سیکیورٹی چیک
                                if (widget.customerPhone == null || widget.customerPhone!.isEmpty) {
                                  Navigator.pop(ctx);
                                  _showSignUpBarrierDialog();
                                  return;
                                }

                                // 3️⃣ کامیاب آرڈر
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('آرڈر $tokenNo کسٹمر ${widget.customerPhone} کے کھاتے میں ایڈمن کو ارسال ہو گیا!'),
                                    backgroundColor: const Color(0xFF059669),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.send_rounded, size: 16),
                              label: const Text('ایڈمن کو باضابطہ آرڈر ارسال کریں'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF059669),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 🔒 سائن اپ / لاگ ان بیریئر پاپ اپ ڈائیلاگ
  void _showSignUpBarrierDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.lock_person_rounded, color: Color(0xFF0D9488), size: 24),
                SizedBox(width: 8),
                Text('باضابطہ رجسٹریشن درکار ہے', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'محترم کسٹمر! آپ ریٹ اور 28 پلانز دیکھ سکتے ہیں لیکن قسطوں پر موبائل کا آرڈر بھیجنے کے لیے آپ کا ہمارے پاس رجسٹرڈ ہونا لازمی ہے۔',
                  style: TextStyle(fontSize: 11.5, height: 1.4, color: Color(0xFF334155)),
                ),
                SizedBox(height: 10),
                Text(
                  '💡 طریقہ کار:\n1. پہلے اپنا سائن اپ فارم پُر کریں۔\n2. ایڈمن تصدیق کے بعد آپ کا کھاتہ منظور کرے گا۔\n3. آپ کے موبائل کے آخری 4 ہندسے ہی آپ کا پاسورڈ (PIN) ہوں گے۔',
                  style: TextStyle(fontSize: 10.5, color: Color(0xFF059669), fontWeight: FontWeight.w600, height: 1.4),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('صرف ریٹ دیکھنا ہے', style: TextStyle(color: Color(0xFF64748B))),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  // سائن اپ پیج پر بھیجنا
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('سائن اپ اسکرین پر بھیجا جا رہا ہے...'),
                      backgroundColor: Color(0xFF0F172A),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('ابھی سائن اپ کریں'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _slipRow(String label, String value, {bool isHighlight = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569))),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold || isHighlight ? FontWeight.bold : FontWeight.w600,
              color: isHighlight ? const Color(0xFF0D9488) : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  void _openSmartCalculatorSheet() {
    final customNameCtrl = TextEditingController();
    final customEstimatePriceCtrl = TextEditingController();
    final customAdvanceCtrl = TextEditingController(text: '0');
    String? validationError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(height: 12),
                      const Text('اپنی مرضی کے موبائل کا تخمینہ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      const SizedBox(height: 4),
                      const Text('موبائل کا نام اور مطلوبہ مالیت درج کریں:', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      const SizedBox(height: 12),
                      TextField(
                        controller: customNameCtrl,
                        decoration: InputDecoration(
                          labelText: 'موبائل ماڈل کا نام',
                          hintText: 'مثلاً Oppo A78 یا Vivo Y200',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: customEstimatePriceCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'مارکیٹ مالیت کا اندازہ (تخمینہ رقم)*',
                          hintText: 'مثلاً 50000',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: customAdvanceCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'متوقع ایڈوانس رقم (بغیر ایڈوانس کے لیے 0 لکھیں)',
                          hintText: '0 یا کم از کم 5000',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                      if (validationError != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          validationError!,
                          style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
                        ),
                      ],
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final estPrice = int.tryParse(customEstimatePriceCtrl.text.trim()) ?? 0;
                            final adv = int.tryParse(customAdvanceCtrl.text.trim()) ?? 0;

                            if (estPrice <= 0) {
                              setSheetState(() => validationError = 'برائے مہربانی درست مالیت درج کریں');
                              return;
                            }

                            if (adv > 0 && adv < 5000) {
                              setSheetState(() => validationError = 'ایڈوانس یا تو 0 ہونا چاہیے یا کم از کم Rs. 5,000');
                              return;
                            }

                            Navigator.pop(ctx);
                            setState(() {
                              _selectedDevice['name'] = customNameCtrl.text.trim().isEmpty ? 'کسٹم ڈیوائس' : customNameCtrl.text.trim();
                              _selectedDevice['baseValue'] = estPrice;
                              _selectedDevice['ramRom'] = 'کسٹمر ڈیمانڈ';
                              _selectedDevice['condition'] = 'نئی یا طلب کے مطابق';
                              _selectedDevice['minAdvanceRequired'] = 5000;
                              _userCustomAdvance = adv;
                              _customAdvanceFilterCtrl.text = adv.toString();
                              _activeViewIndex = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('28 اقساطی پیکجز کا شیڈول دیکھیں', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}