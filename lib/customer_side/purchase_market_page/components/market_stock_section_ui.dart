import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/purchase_market_controller.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/components/market_stock_list_header_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/components/stock_phone_card_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/purchase_market_page/components/market_empty_stock_ui.dart';

class MarketStockSectionUi extends StatelessWidget {
  final PurchaseMarketController controller;
  final String? customerPhone;

  const MarketStockSectionUi({
    super.key,
    required this.controller,
    this.customerPhone,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: controller.stockListenable,
      builder: (context, _, __) {
        final stockDevices = controller.getStockDevices();

        return AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarketStockListHeaderUi(totalCount: stockDevices.length),
                const SizedBox(height: 10),
                if (stockDevices.isEmpty)
                  const MarketEmptyStockUi()
                else
                  ...List.generate(
                    stockDevices.length,
                    (idx) {
                      final item = stockDevices[idx];
                      return StockPhoneCardUi(
                        item: item,
                        isRibbonExpanded: controller.expandedCardIndex == idx,
                        totalPlans: controller.totalPlansCount,
                        onCardTap: () => controller.navigateToPlanDetail(context, item, customerPhone),
                        onToggleRibbon: () => controller.toggleRibbon(idx),
                      );
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}