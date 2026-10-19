import 'package:flutter/material.dart';
import 'benchmark_args.dart';
import 'benchmark_controller.dart';
import 'components/benchmark_app_bar_ui.dart';
import 'components/benchmark_page_tab_ui.dart';
import 'components/benchmark_box_tab_ui.dart';
import 'components/benchmark_live_tab_ui.dart';

class BenchmarkPage extends StatefulWidget {
  final BenchmarkArgs? args;

  const BenchmarkPage({super.key, this.args});

  @override
  State<BenchmarkPage> createState() => _BenchmarkPageState();
}

class _BenchmarkPageState extends State<BenchmarkPage> with SingleTickerProviderStateMixin {
  late final BenchmarkController controller;
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    controller = BenchmarkController(args: widget.args);
    tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: controller.currentTabIndex,
    );
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        controller.setTab(tabController.index);
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: BenchmarkAppBarUi(
          activeTabIndex: controller.currentTabIndex,
          onClearLogs: controller.clearLogs,
          onCopyAll: () {},
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: tabController,
                indicatorColor: const Color(0xFF059669),
                indicatorWeight: 3,
                labelColor: const Color(0xFF059669),
                unselectedLabelColor: const Color(0xFF64748B),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(text: '1. پیج وائز اسکیما (Pages)'),
                  Tab(text: '2. ہائیو باکسز میٹرکس (Boxes)'),
                  Tab(text: '3. لائیو فلائٹ ریکارڈر (Live Logs)'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  const BenchmarkPageTabUi(),
                  BenchmarkBoxTabUi(
                    onPageChipTapped: (pageName) {
                      tabController.animateTo(0);
                    },
                  ),
                  const BenchmarkLiveTabUi(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}