import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:qubic_wallet/components/account_list_item.dart';
import 'package:qubic_wallet/components/cumulative_wallet_value_sliver.dart';
import 'package:qubic_wallet/components/gradient_container.dart';
import 'package:qubic_wallet/components/id_list_item.dart';
import 'package:qubic_wallet/components/sliver_button.dart';
import 'package:qubic_wallet/components/tick_indication_styled.dart';
import 'package:qubic_wallet/components/tick_indicator.dart';
import 'package:qubic_wallet/components/tick_refresh.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/platform_helpers.dart';
import 'package:qubic_wallet/helpers/show_alert_dialog.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/add_account.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';
import 'package:qubic_wallet/timed_controller.dart';

class TabWalletContents extends StatefulWidget {
  const TabWalletContents({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TabWalletContentsState createState() => _TabWalletContentsState();
}

class _TabWalletContentsState extends State<TabWalletContents> {
  final ApplicationStore appStore = getIt<ApplicationStore>();
  final TimedController _timedController = getIt<TimedController>();

  final double sliverCollapsed = 80;
  final double sliverExpanded = 203;

  double _sliverShowPercent = 1;

  ScrollController _scrollController = ScrollController();
  String? signInError;
  // int? currentTick;

  ReactionDisposer? disposeAutorun;

  @override
  void initState() {
    super.initState();

    disposeAutorun = autorun((_) {
      if (appStore.currentQubicIDs.length <= 1) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut);
        }
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.offset > sliverExpanded) {
        debugPrint("100%");
      }

      setState(() {
        _sliverShowPercent =
            1 - (_scrollController.offset / (sliverExpanded - sliverCollapsed));
        if (_sliverShowPercent < 0) {
          _sliverShowPercent = 0;
        }
        if (_sliverShowPercent > 1) _sliverShowPercent = 1;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    disposeAutorun!();
    _scrollController.dispose();
    // disposer();
  }

  List<Widget> getAccounts() {
    List<Widget> accounts = [];
    for (var element in appStore.currentQubicIDs) {
      accounts.add(Padding(
          padding: const EdgeInsets.symmetric(
              vertical: ThemePaddings.normalPadding / 2),
          child: IdListItem(item: element)));
    }
    return accounts;
  }

  List<Widget> getAccountCards() {
    List<Widget> cards = [];

    cards.add(Container());

    cards.add(CumulativeWalletValueSliver());

    for (var element in appStore.currentQubicIDs) {
      cards.add(Padding(
          padding: const EdgeInsets.symmetric(
              vertical: ThemePaddings.normalPadding / 2),
          child: IdListItem(item: element)));
    }
    return cards;
  }

  Widget getEmptyWallet() {
    Color? transpColor =
        Theme.of(context).textTheme.titleMedium?.color!.withOpacity(0.3);
    return Center(
        child: DottedBorder(
            color: transpColor!,
            strokeWidth: 3,
            borderType: BorderType.RRect,
            radius: const Radius.circular(20),
            dashPattern: const [10, 5],
            child: Padding(
              padding: const EdgeInsets.all(ThemePaddings.bigPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wallet_outlined,
                      size: 100,
                      color: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.color!
                          .withOpacity(0.3)),
                  const Text("No Qubic IDs in wallet yet"),
                  ThemedControls.spacerVerticalNormal(),
                  FilledButton.icon(
                      onPressed: () {
                        pushNewScreen(
                          context,
                          screen: const AddAccount(),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      icon: const Icon(Icons.add_box),
                      label: const Text("Add new ID"))
                ],
              ),
            )));
  }

  bool isLoading = false;

  void addAccount() {
    if (appStore.currentQubicIDs.length >= 15) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return getAlertDialog("Max accounts limit reached",
                "You can only have up to 15 Qubic IDs in your wallet. If you need to add another ID please remove one from your existing IDs",
                primaryButtonLabel: "OK", primaryButtonFunction: () {
              Navigator.of(context).pop();
            }, secondaryButtonFunction: () {
              Navigator.of(context).pop();
            }, secondaryButtonLabel: "Cancel");
          });

      return;
    }
    pushNewScreen(
      context,
      screen: const AddAccount(),
      withNavBar: false, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () async {
              await _timedController.interruptFetchTimer();
            },
            child: Container(
              color: LightThemeColors.backkground,
              child: CustomScrollView(
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    backgroundColor: LightThemeColors.backkground,

                    actions: <Widget>[
                      TickRefresh(),
                      ThemedControls.spacerHorizontalSmall(),
                      SliverButton(
                        icon: const Icon(Icons.add,
                            color: LightThemeColors.primary),
                        onPressed: addAccount,
                      ),
                      ThemedControls.spacerHorizontalSmall(),
                    ],
                    floating: false,
                    pinned: true,
                    collapsedHeight: sliverCollapsed,
                    //title: Text("Flexible space title"),
                    expandedHeight: sliverExpanded,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(child: GradientContainer()),
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
                                      textStyle: TextStyles.whiteTickText))),
                          Transform.translate(
                              offset: Offset(0, -10 * (1 - _sliverShowPercent)),
                              child: Opacity(
                                  opacity: _sliverShowPercent,
                                  child: CumulativeWalletValueSliver())),
                        ])),
                        Positioned(
                          bottom: -7,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 33,
                            decoration: const BoxDecoration(
                              color: LightThemeColors.backkground,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(40),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                ThemePaddings.normalPadding,
                                ThemePaddings.smallPadding,
                                ThemePaddings.normalPadding,
                                ThemePaddings.miniPadding),
                            child: Text("Qubic IDs in wallet",
                                style: TextStyles.sliverCardPreLabel)))
                  ])),
                  Observer(builder: (context) {
                    if (appStore.currentQubicIDs.length == 0) {
                      return SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        return Container(
                            color: LightThemeColors.backkground,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: ThemePaddings.smallPadding,
                                    vertical: ThemePaddings.normalPadding / 2),
                                child: DottedBorder(
                                    color: LightThemeColors.color3,
                                    child: Padding(
                                        padding: EdgeInsets.all(
                                            ThemePaddings.smallPadding),
                                        child: Expanded(
                                            child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.all(
                                                    ThemePaddings.bigPadding),
                                                color: LightThemeColors
                                                    .cardBackground,
                                                child: Column(children: [
                                                  ThemedControls
                                                      .spacerVerticalBig(),
                                                  Text(
                                                      "You don't have any Qubic Accounts in your wallet yet"),
                                                  ThemedControls
                                                      .spacerVerticalBig(),
                                                  ThemedControls
                                                      .primaryButtonBigWithChild(
                                                          onPressed: addAccount,
                                                          child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Icon(Icons.add),
                                                                ThemedControls
                                                                    .spacerHorizontalSmall(),
                                                                Text(
                                                                    "Add new Account"),
                                                              ])),
                                                  ThemedControls
                                                      .spacerVerticalBig(),
                                                ])))))));
                      }, childCount: 1));
                    } else {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Container(
                              color: LightThemeColors.backkground,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: ThemePaddings.smallPadding,
                                      vertical:
                                          ThemePaddings.normalPadding / 2),
                                  child: AccountListItem(
                                      item: appStore.currentQubicIDs[index])));
                        }, childCount: appStore.currentQubicIDs.length),
                      );
                    }
                  }),
                ],
              ),
            )));
  }
}
