import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/purchase_market_controller.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/components/market_app_bar_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/components/luminous_calculator_banner_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/components/custom_estimate_sheet_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/components/market_stock_section_ui.dart';

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
    CustomEstimateSheetUi.show(
      context,
      onSubmit: (name, price, adv) {
        Navigator.pop(context);
        _controller.handleCustomEstimateSubmit(
          context, 
          name, 
          price, 
          adv, 
          widget.customerPhone,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: MarketAppBarUi(customerPhone: widget.customerPhone),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LuminousCalculatorBannerUi(onEstimateTap: _openCustomEstimateSheet),
              const SizedBox(height: 16),
              MarketStockSectionUi(
                controller: _controller,
                customerPhone: widget.customerPhone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}