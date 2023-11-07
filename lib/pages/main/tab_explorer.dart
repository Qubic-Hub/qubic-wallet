import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:pagination_flutter/pagination.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qubic_wallet/components/epoch_indicator.dart';
import 'package:qubic_wallet/components/explorer_results/explorer_loading_indicator.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/globals.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/explorer/explorer_search.dart';
import 'package:qubic_wallet/resources/qubic_li.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/stores/explorer_store.dart';
import 'package:qubic_wallet/timed_controller.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'wallet_contents/explorer/explorer_result_page.dart';

class TabExplorer extends StatefulWidget {
  const TabExplorer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TabExplorerState createState() => _TabExplorerState();
}

class _TabExplorerState extends State<TabExplorer> {
  final ApplicationStore appStore = getIt<ApplicationStore>();
  final ExplorerStore explorerStore = getIt<ExplorerStore>();
  final QubicLi li = getIt<QubicLi>();
  final TimedController _timedController = getIt<TimedController>();

  //Pagination Related
  int numberOfPages = 0;
  int currentPage = 1;
  int itemsPerPage = 1000;

  late final disposeReaction =
      reaction((_) => explorerStore.networkOverview, (value) {
    if (explorerStore.networkOverview != null) {
      //Calculate number of pages
      setState(() {
        numberOfPages =
            (explorerStore.networkOverview!.ticks.length / itemsPerPage).ceil();
        currentPage = 1;
      });
    } else {
      _timedController.interruptFetchTimer();
    }
  });

  void refreshOverview() {
    explorerStore.incrementPendingRequests();

    li.getNetworkOverview().then((value) {
      explorerStore.setNetworkOverview(value);
      explorerStore.decreasePendingRequests();
      setState(() {
        numberOfPages =
            (explorerStore.networkOverview!.ticks.length / itemsPerPage).ceil();
        currentPage = 1;
      });
    }, onError: (e) {
      SnackBar snackBar =
          SnackBar(content: Text(e.toString().replaceAll("Exception: ", "")));
      snackbarKey.currentState?.showSnackBar(snackBar);
      explorerStore.decreasePendingRequests();
    });
  }

  @override
  void initState() {
    super.initState();
    if (explorerStore.networkOverview == null) {
      refreshOverview();
    }
  }

  @override
  void dispose() {
    super.dispose();
    disposeReaction();
    // disposer();
  }

  Widget getEmptyExplorer() {
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
                  Icon(Icons.account_tree,
                      size: 100,
                      color: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.color!
                          .withOpacity(0.3)),
                  const Text("Loading explorer data for this epoch"),
                  const SizedBox(height: ThemePaddings.normalPadding),
                  Observer(builder: (context) {
                    if (explorerStore.pendingRequests > 0) {
                      return const CircularProgressIndicator();
                    } else {
                      return FilledButton.icon(
                          onPressed: () async {
                            refreshOverview();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("Refresh data"));
                    }
                  }),
                ],
              ),
            )));
  }

  Widget getPagination() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Pagination(
            numOfPages: numberOfPages,
            selectedPage: currentPage,
            pagesVisible: 3,
            onPageChanged: (page) {
              setState(() {
                currentPage = page;
              });
            },
            nextIcon: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.secondary,
              size: 14,
            ),
            previousIcon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.secondary,
              size: 14,
            ),
            activeTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            activeBtnStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.secondary),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(38),
                ),
              ),
            ),
            inactiveBtnStyle: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(38),
              )),
            ),
            inactiveTextStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
    );
  }

  List<Widget> getExplorerContents() {
    List<Widget> cards = [];

    cards.add(Observer(builder: (context) {
      if (explorerStore.networkOverview == null) {
        return getEmptyExplorer();
      }

      return Column(children: [
        Text("Epoch explorer",
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(fontFamily: ThemeFonts.primary)),
        const SizedBox(height: ThemePaddings.normalPadding),
        Flex(direction: Axis.horizontal, children: [
          Expanded(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: ThemePaddings.normalPadding / 2),
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    Text("Total Ticks",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontFamily: ThemeFonts.secondary)),
                    Text(
                        explorerStore.networkOverview!.numberOfTicks
                            .asThousands(),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontFamily: ThemeFonts.primary)),
                  ]))),
          Expanded(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: ThemePaddings.normalPadding / 2),
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    Text("Empty Ticks",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontFamily: ThemeFonts.secondary)),
                    Text(
                        explorerStore.networkOverview!.numberOfEmptyTicks
                            .asThousands()
                            .toString(),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontFamily: ThemeFonts.primary)),
                  ]))),
          Expanded(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: ThemePaddings.normalPadding / 2),
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    Text("Tick Quality",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontFamily: ThemeFonts.secondary)),
                    Text(
                        "${explorerStore.networkOverview!.tickQualityPercentage}%",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontFamily: ThemeFonts.primary)),
                  ])))
        ]),
        Flex(direction: Axis.horizontal, children: [
          Expanded(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: ThemePaddings.normalPadding / 2),
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    Text("Total supply",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontFamily: ThemeFonts.secondary)),
                    FittedBox(
                        child: QubicAmount(
                            amount: explorerStore.networkOverview!.supply))
                  ]))),
          Expanded(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: ThemePaddings.normalPadding / 2),
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    Text("Total Public IDs",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontFamily: ThemeFonts.secondary)),
                    Text(
                        explorerStore.networkOverview!.numberOfEntities
                            .asThousands()
                            .toString(),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontFamily: ThemeFonts.primary)),
                  ])))
        ]),
        const Divider(),
        const SizedBox(height: ThemePaddings.normalPadding),
        //Starts here
        Container(
            color: Theme.of(context).colorScheme.background,
            width: double.infinity,
            child: const Text(
              "Tick overview - Latest ticks",
              textAlign: TextAlign.center,
            )),
        StickyHeader(
            header: Container(
                height: 50.0,
                color: Theme.of(context).colorScheme.background,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: getPagination()),
            content: Observer(builder: (context) {
              List<Widget> items = [];
              int min = (currentPage - 1) * itemsPerPage;
              int max = currentPage * itemsPerPage;
              if (min < 0) {
                min = 0;
              }
              if (max > explorerStore.networkOverview!.ticks.length) {
                max = explorerStore.networkOverview!.ticks.length;
              }

              List<Widget> lineWidget = [];
              int lineCount = 0;
              for (var i = min; i < max; i++) {
                lineWidget.add(TextButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: ExplorerResultPage(
                            resultType: ExplorerResultType.tick,
                            tick: explorerStore.networkOverview!.ticks[i].tick),
                        //TransactionsForId(publicQubicId: item.publicId),
                        withNavBar: false, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    child: FittedBox(
                        child: Text(
                            explorerStore.networkOverview!.ticks[i].tick
                                .asThousands()
                                .toString(),
                            style: Theme.of(context)
                                .primaryTextTheme
                                .titleSmall
                                ?.copyWith(
                                    color: explorerStore.networkOverview!
                                            .ticks[i].arbitrated
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary)))));
                if (lineCount == 2) {
                  items.add(Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: lineWidget));
                  lineWidget = [];
                  lineCount = 0;
                } else {
                  lineCount++;
                }
              }

              return Column(
                children: items,
              );
            })),
        //Ends here
      ]);
    }));

    //Text("Explorer info"));

    return cards;
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        EpochIndicator(),
                        ExplorerLoadingIndicator(),
                        Expanded(child: Container()),
                        IconButton(
                          onPressed: () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: const ExplorerSearch(),
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
                          icon: const Icon(Icons.search),
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    )))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            refreshOverview();
          },
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Wrap(
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: getExplorerContents())),
        ));
  }
}
