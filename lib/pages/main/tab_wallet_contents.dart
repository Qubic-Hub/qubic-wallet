import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qubic_wallet/components/cumulative_wallet_value.dart';
import 'package:qubic_wallet/components/id_list_item.dart';
import 'package:qubic_wallet/components/tick_indicator.dart';
import 'package:qubic_wallet/components/tick_refresh.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/platform_helpers.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/add_account.dart';
import 'package:qubic_wallet/stores/application_store.dart';
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
  String? signInError;
  // int? currentTick;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // disposer();
  }

  List<Widget> getAccountCards() {
    List<Widget> cards = [];

    cards.add(Container());

    if (appStore.currentQubicIDs.length > 1) {
      cards.add(CumulativeWalletValue());
    }

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
                  const SizedBox(height: ThemePaddings.normalPadding),
                  FilledButton.icon(
                      onPressed: () {
                        PersistentNavBarNavigator.pushNewScreen(
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
                                screen: const AddAccount(),
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
                            icon: const Icon(Icons.add_box),
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
                      return getEmptyWallet();
                    }
                    return Wrap(
                        runAlignment: WrapAlignment.center,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: getAccountCards());
                  }))),
        ));
  }
}
