import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'customer_ledger_args.dart';
import 'customer_ledger_controller.dart';
import 'services/ledger_storage_handler.dart';
import 'components/ledger_app_bar_ui.dart';
import 'components/frozen_bottom_action_bar_ui.dart';
import 'components/ledger_dashboard_body_ui.dart';

class CustomerLedgerView extends StatefulWidget {
  final CustomerLedgerArgs? args;
  final String? customerPhone;

  const CustomerLedgerView({
    super.key,
    this.args,
    this.customerPhone,
  });

  @override
  State<CustomerLedgerView> createState() => _CustomerLedgerViewState();
}

class _CustomerLedgerViewState extends State<CustomerLedgerView> {
  late final CustomerLedgerController controller;

  @override
  void initState() {
    super.initState();
    final effectiveArgs = widget.args ??
        CustomerLedgerArgs(customerPhone: widget.customerPhone ?? '');
    controller = CustomerLedgerController(args: effectiveArgs);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (controller.customerPhone.isEmpty) {
      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      if (routeArgs is Map && routeArgs['customerPhone'] != null) {
        controller.customerPhone = routeArgs['customerPhone'].toString();
        controller.refreshDashboardData();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listenable = LedgerStorageHandler.customerBoxListenable;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: const LedgerAppBarUi(),
        body: listenable == null
            ? AnimatedBuilder(
                animation: controller,
                builder: (_, __) => LedgerDashboardBodyUi(controller: controller),
              )
            : ValueListenableBuilder<Box>(
                valueListenable: listenable,
                builder: (_, __, ___) {
                  controller.refreshDashboardData();
                  return AnimatedBuilder(
                    animation: controller,
                    builder: (_, __) => LedgerDashboardBodyUi(controller: controller),
                  );
                },
              ),
        bottomNavigationBar: FrozenBottomActionBarUi(
          onStatementPressed: () => controller.openStatementSheet(context),
          onPurchasePressed: () => controller.openPurchaseMarket(context),
        ),
      ),
    );
  }
}