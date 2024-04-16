import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:qubic_wallet/components/gradient_container.dart';
import 'package:qubic_wallet/components/sliver_button.dart';
import 'package:qubic_wallet/components/tick_indication_styled.dart';
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
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';
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

  final double sliverCollapsed = 80;
  final double sliverExpanded = 80;

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
        body: RefreshIndicator(
            onRefresh: () async {
              await _timedController.interruptFetchTimer();
            },
            child: Container(
                color: LightThemeColors.backkground,
                child: CustomScrollView(slivers: [
                  SliverAppBar(
                      backgroundColor: LightThemeColors.backkground,
                      actions: <Widget>[
                        TickRefresh(),
                        ThemedControls.spacerHorizontalSmall(),
                        SliverButton(
                          icon: const Icon(Icons.filter_list,
                              color: LightThemeColors.primary),
                          onPressed: () {
                            pushNewScreen(
                              context,
                              screen: const FilterTransactions(),
                              withNavBar:
                                  false, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                        ),
                        ThemedControls.spacerHorizontalSmall(),
                      ],
                      floating: false,
                      pinned: true,
                      collapsedHeight: sliverCollapsed,
                      //title: Text("Flexible space title"),
                      expandedHeight: sliverExpanded,
                      flexibleSpace: Stack(children: [
                        Positioned.fill(
                            child: Column(children: [
                          Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0,
                                  ThemePaddings.normalPadding,
                                  0,
                                  ThemePaddings.normalPadding),
                              child: Center(
                                  child: TickIndicatorStyled(
                                      textStyle: TextStyles.blackTickText)))
                        ])),
                      ])),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                ThemePaddings.bigPadding,
                                ThemePaddings.normalPadding,
                                ThemePaddings.bigPadding,
                                ThemePaddings.miniPadding),
                            child: Text("Epoch Transfers",
                                style: TextStyles.sliverCardPreLabel)))
                  ])),
                  Observer(builder: (context) {
                    if (appStore.currentTransactions.isEmpty) {
                      return SliverList(
                          delegate: SliverChildListDelegate([
                        Container(
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    ThemePaddings.bigPadding,
                                    ThemePaddings.normalPadding,
                                    ThemePaddings.bigPadding,
                                    ThemePaddings.miniPadding),
                                child: getEmptyTransactions(
                                    context: context,
                                    hasFiltered: false,
                                    numberOfFilters: null,
                                    onTap: () {})))
                      ]));
                    }
                    List<TransactionVm> filteredResults = [];

                    appStore.currentTransactions.reversed.forEach((tran) {
                      if ((appStore.transactionFilter == null) ||
                          (appStore.transactionFilter!.matchesVM(tran))) {
                        filteredResults.add(tran);
                      }
                    });
                    if (filteredResults.isEmpty) {
                      return SliverList(
                          delegate: SliverChildListDelegate([
                        Container(
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    ThemePaddings.bigPadding,
                                    ThemePaddings.normalPadding,
                                    ThemePaddings.bigPadding,
                                    ThemePaddings.miniPadding),
                                child: getEmptyTransactions(
                                    context: context,
                                    hasFiltered: true,
                                    numberOfFilters:
                                        appStore.transactionFilter == null
                                            ? null
                                            : appStore.transactionFilter!
                                                .totalActiveFilters,
                                    onTap: () {
                                      appStore.clearTransactionFilters();
                                    })))
                      ]));
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Container(
                            color: LightThemeColors.backkground,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: ThemePaddings.bigPadding,
                                    vertical: ThemePaddings.normalPadding / 2),
                                child: TransactionItem(
                                    item: filteredResults[index])));
                      }, childCount: filteredResults.length),
                    );
                  }),
                ]))));
  }
}
