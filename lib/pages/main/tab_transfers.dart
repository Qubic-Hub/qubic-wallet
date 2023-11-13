import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qubic_wallet/components/tick_indicator.dart';
import 'package:qubic_wallet/components/tick_refresh.dart';
import 'package:qubic_wallet/components/transaction_item.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/transaction_UI_helpers.dart';
import 'package:qubic_wallet/models/transaction_filter.dart';
import 'package:qubic_wallet/models/transaction_vm.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/transfers/filter_transactions.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/timed_controller.dart';

class TabTransfers extends StatefulWidget {
  const TabTransfers({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TabTransfersState createState() => _TabTransfersState();
}

class _TabTransfersState extends State<TabTransfers> {
  final ApplicationStore appStore = getIt<ApplicationStore>();
  final TimedController _timedController = getIt<TimedController>();

  String? filterQubicId;
  ComputedTransactionStatus? filterStatus;
  TransactionFilter? filter;

  Widget clearFiltersButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          appStore.clearTransactionFilters();
        },
        child: Text(
            appStore.transactionFilter?.totalActiveFilters == 1
                ? "Clear 1 active filter"
                : "Clear ${appStore.transactionFilter?.totalActiveFilters} active filters",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontFamily: ThemeFonts.secondary)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        ThemePaddings.normalPadding,
                        0,
                        ThemePaddings.normalPadding,
                        0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TickIndicator(),
                        Row(children: [
                          TickRefresh(),
                          IconButton(
                            onPressed: () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: const FilterTransactions(),
                                withNavBar:
                                    false, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                              );
                            },
                            iconSize: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.fontSize,
                            icon: const Icon(Icons.filter_list),
                            color: Theme.of(context).primaryColor,
                          )
                        ]),
                      ],
                    )))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _timedController.interruptFetchTimer();
          },
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(ThemePaddings.smallPadding,
                      0, ThemePaddings.smallPadding, 0),
                  child: Observer(builder: (context) {
                    if (appStore.currentQubicIDs.isEmpty) {
                      return Column(
                          children: [getEmptyTransactions(context, false)]);
                    }
                    return Wrap(
                        runAlignment: WrapAlignment.center,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text("Epoch Transactions",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(fontFamily: ThemeFonts.primary)),
                          Observer(builder: (context) {
                            List<Widget> results = [];
                            if (appStore.transactionFilter!.totalActiveFilters >
                                0) {
                              results.add(clearFiltersButton(context));
                            }
                            int added = 0;
                            appStore.currentTransactions.reversed
                                .forEach((tran) {
                              if ((appStore.transactionFilter == null) ||
                                  (appStore.transactionFilter!
                                      .matchesVM(tran))) {
                                added++;
                                results.add(const SizedBox(
                                    height: ThemePaddings.normalPadding));
                                results.add(TransactionItem(item: tran));
                              }
                            });
                            if (added == 0) {
                              results.add(const SizedBox(
                                  height: ThemePaddings.normalPadding));
                              results.add(getEmptyTransactions(context,
                                  appStore.currentTransactions.isNotEmpty));
                            } else {
                              results.add(const SizedBox(
                                  height: ThemePaddings.normalPadding));
                            }
                            return Column(children: results);
                          })
                        ]);
                  }))),
        ));
  }
}
