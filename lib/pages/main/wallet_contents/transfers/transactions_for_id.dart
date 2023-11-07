import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:qubic_wallet/components/tick_indicator.dart';
import 'package:qubic_wallet/components/transaction_item.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/transaction_UI_helpers.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/models/transaction_filter.dart';

import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/timed_controller.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class TransactionsForId extends StatefulWidget {
  final String publicQubicId;
  const TransactionsForId({super.key, required this.publicQubicId});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionsForIdState createState() => _TransactionsForIdState();
}

class _TransactionsForIdState extends State<TransactionsForId> {
  final ApplicationStore appStore = getIt<ApplicationStore>();
  final TimedController _timedController = getIt<TimedController>();

  QubicListVm? walletItem;
  bool showFilterForm = false;
  TransactionDirection? selectedDirection;
  final _formKey = GlobalKey<FormBuilderState>();

  List<Widget> getDirectionLabel(TransactionDirection? e) {
    List<Widget> out = [];
    if (e == null) {
      out.add(const Icon(Icons.clear));
      out.add(Text(
        "All transactions",
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontStyle: FontStyle.italic),
      ));
    } else {
      out.add(Icon(e == TransactionDirection.incoming
          ? Icons.input_outlined
          : Icons.output_outlined));
      out.add(const Text(" "));
      out.add(
          Text(e == TransactionDirection.incoming ? "Incoming" : "Outgoing"));
    }
    return out;
  }

  Widget getDirectionDropdown() {
    List<TransactionDirection?> directionOptions = [
      null,
      TransactionDirection.incoming,
      TransactionDirection.outgoing
    ];

    List<DropdownMenuItem> items = directionOptions
        .map((e) => DropdownMenuItem<TransactionDirection?>(
            value: e,
            child: Column(children: [
              Row(children: getDirectionLabel(e)),
              const Divider()
            ])))
        .toList();

    return FormBuilderDropdown(
        name: "direction",
        icon: SizedBox(height: 2, child: Container()),
        onChanged: (value) {
          setState(() {
            selectedDirection = value;
          });
        },
        initialValue: selectedDirection,
        decoration: InputDecoration(
          labelText: 'Filter by direction',
          suffix: selectedDirection == null
              ? const SizedBox(height: 10)
              : SizedBox(
                  height: 25,
                  width: 25,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.close, size: 15.0),
                    onPressed: () {
                      _formKey.currentState!.fields['direction']
                          ?.didChange(null);
                      setState(() {
                        selectedDirection = null;
                      });
                      // _formKey.currentState!.fields['status']?.setState(() {
                      //   _formKey.currentState!.fields['status']?.didChange(null);
                      // });
                    },
                  )),
          hintText: 'By Direction',
        ),
        selectedItemBuilder: (BuildContext context) {
          return items.map<Widget>((item) {
            // This is the widget that will be shown when you select an item.
            // Here custom text style, alignment and layout size can be applied
            // to selected item string.

            return Container(
              alignment: Alignment.centerLeft,
              child: Row(
                  children: item.value != null
                      ? getDirectionLabel(item.value)
                      : [
                          Text(
                            "Any direction",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontStyle: FontStyle.italic),
                          )
                        ]),
            );
          }).toList();
        },
        items: items);
  }

  @override
  void initState() {
    super.initState();
    walletItem = appStore.currentQubicIDs.firstWhereOrNull(
        (element) => element.publicId == widget.publicQubicId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(ThemePaddings.normalPadding, 0,
                  ThemePaddings.normalPadding, 0),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      ThemePaddings.hugePadding, 0, 0, 0),
                  child: TickIndicator()),
            ))
          ],
        ),
        body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(ThemePaddings.normalPadding, 0,
                ThemePaddings.normalPadding, ThemePaddings.miniPadding),
            child: RefreshIndicator(
              onRefresh: () async {
                await _timedController.interruptFetchTimer();
              },
              child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Observer(builder: (context) {
                    return Wrap(
                        runAlignment: WrapAlignment.center,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text("Transactions for",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(fontFamily: ThemeFonts.primary)),
                          Text(widget.publicQubicId,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontFamily: ThemeFonts.primary)),
                          Container(
                              margin: const EdgeInsets.all(
                                  ThemePaddings.miniPadding)),
                          Observer(builder: (context) {
                            List<Widget> results = [];
                            int added = 0;
                            appStore.currentTransactions.reversed
                                .forEach((tran) {
                              if ((appStore.transactionFilter == null) ||
                                  (appStore.transactionFilter!
                                      .matchesVM(tran))) {
                                added++;

                                results.add(TransactionItem(item: tran));
                                results.add(const SizedBox(
                                    height: ThemePaddings.normalPadding));
                              }
                            });
                            if (added == 0) {
                              results.add(getEmptyTransactions(context,
                                  appStore.currentTransactions.isNotEmpty));
                            }
                            return Column(children: results);
                          })
                        ]);
                  })),
            )));
  }
}
