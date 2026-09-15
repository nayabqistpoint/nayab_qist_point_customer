import 'package:flutter/material.dart';
import 'purchase_market_controller.dart';
import 'components/market_app_bar_ui.dart';
import 'components/luminous_calculator_banner_ui.dart';
import 'components/market_stock_list_header_ui.dart';
import 'components/stock_phone_card_ui.dart';
import 'components/custom_estimate_sheet_ui.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';

class PurchaseMarketPage extends StatefulWidget {
  final String? customerPhone;

  const PurchaseMarketPage({super.key, this.customerPhone});

  @override
  State<PurchaseMarketPage> createState() => _PurchaseMarketPageState();
}

class _PurchaseMarketPageState extends State<PurchaseMarketPage> {
  late final PurchaseMarketController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PurchaseMarketController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openCustomEstimateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => CustomEstimateSheetUi(
        onSubmit: (name, price, adv) {
          // 1. پہلے کھلی ہوئی باٹم شیٹ کو بند کریں
          Navigator.pop(sheetContext);

          // 2. کسٹم ڈیوائس ڈیٹا بنائیں
          final device = {
            'name': name.isEmpty ? 'کسٹم ڈیوائس تخمینہ' : name,
            'baseValue': price,
            'ramRom': 'کسٹمر ڈیمانڈ',
            'condition': 'نئی یا طلب کے مطابق',
            'warranty': '12 ماہ وارنٹی',
            'minAdvanceRequired': adv > 0 ? adv : 5000,
            'userCustomAdvance': adv,
            'isCustomEstimate': true,
            'images': [
              'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=800',
            ],
          };

          // 3. 28 اقساط والے پیج پر نیویگیٹ کریں
          Navigator.pushNamed(
            context,
            AppRoutes.planDetail,
            arguments: {
              'device': device,
              'customerPhone': widget.customerPhone,
            },
          );
        },
      ),
    );
  }

  void _navigateToDetailPage(Map<String, dynamic> item) {
    Navigator.pushNamed(
      context,
      AppRoutes.planDetail,
      arguments: {
        'device': item,
        'customerPhone': widget.customerPhone,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFF1F5F9),
            appBar: MarketAppBarUi(
              customerPhone: widget.customerPhone,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LuminousCalculatorBannerUi(
                    onEstimateTap: _openCustomEstimateSheet,
                  ),
                  const SizedBox(height: 16),
                  MarketStockListHeaderUi(
                    totalCount: _controller.stockItems.length,
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(
                    _controller.stockItems.length,
                    (idx) {
                      final item = _controller.stockItems[idx];
                      return StockPhoneCardUi(
                        item: item,
                        isRibbonExpanded: _controller.expandedCardIndex == idx,
                        onCardTap: () => _navigateToDetailPage(item),
                        onToggleRibbon: () => _controller.toggleRibbon(idx),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}