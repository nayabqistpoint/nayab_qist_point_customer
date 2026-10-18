import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/purchase_market_args.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/purchase_market_controller.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/components/market_app_bar_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/components/luminous_calculator_banner_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/components/custom_estimate_sheet_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/components/market_stock_section_ui.dart';

class PurchaseMarketPage extends StatefulWidget {
  final PurchaseMarketArgs? args;

  const PurchaseMarketPage({super.key, this.args});

  @override
  State<PurchaseMarketPage> createState() => _PurchaseMarketPageState();
}

class _PurchaseMarketPageState extends State<PurchaseMarketPage> {
  late final PurchaseMarketController _controller;
  String? _customerPhone;

  @override
  void initState() {
    super.initState();
    _controller = PurchaseMarketController();
    _customerPhone = widget.args?.customerPhone;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_customerPhone == null) {
      final modalArgs = ModalRoute.of(context)?.settings.arguments;
      if (modalArgs is PurchaseMarketArgs) {
        _customerPhone = modalArgs.customerPhone;
      } else if (modalArgs is Map<String, dynamic>) {
        _customerPhone = PurchaseMarketArgs.fromMap(modalArgs).customerPhone;
      }
    }
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
          _customerPhone,
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
        appBar: MarketAppBarUi(customerPhone: _customerPhone),
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
                customerPhone: _customerPhone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}