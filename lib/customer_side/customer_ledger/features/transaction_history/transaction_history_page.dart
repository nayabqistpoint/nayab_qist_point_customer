import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'transaction_history_args.dart';
import 'transaction_history_controller.dart';
import 'components/transaction_filter_bar_ui.dart';
import 'components/transaction_card_tile_ui.dart';

class TransactionHistoryPage extends StatefulWidget {
  final TransactionHistoryArgs args;

  const TransactionHistoryPage({
    super.key,
    required this.args,
  });

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  late final TransactionHistoryController controller;

  @override
  void initState() {
    super.initState();
    controller = TransactionHistoryController(args: widget.args);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final items = controller.filteredTransactions;

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TransactionFilterBarUi(
            selectedIndex: controller.selectedFilterIndex,
            onFilterSelected: controller.setFilter,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'رسیدیں و واٹرفال تفصیلات:',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Text(
                  'تعداد: ${items.length}',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: items.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Center(
                      child: Text(
                        'اس فلٹر کے مطابق کوئی رسید یا ٹرانزیکشن موجود نہیں ہے۔',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return TransactionCardTileUi(
                        transaction: items[index],
                        formatAmount: controller.formatAmount,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listenable = controller.boxListenable;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF0F172A),
          title: const Text(
            'ٹرانزیکشن ریکارڈ و رسیدیں',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: listenable == null
            ? AnimatedBuilder(
                animation: controller,
                builder: (context, _) => _buildBody(),
              )
            : ValueListenableBuilder<Box>(
                valueListenable: listenable,
                builder: (context, _, __) {
                  controller.loadTransactions();
                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) => _buildBody(),
                  );
                },
              ),
      ),
    );
  }
}