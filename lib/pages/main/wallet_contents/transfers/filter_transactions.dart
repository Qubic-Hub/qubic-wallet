import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:qubic_wallet/components/id_list_item_select.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/transaction_UI_helpers.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/models/transaction_filter.dart';
import 'package:qubic_wallet/models/transaction_vm.dart';

import 'package:qubic_wallet/stores/application_store.dart';

class FilterTransactions extends StatefulWidget {
  const FilterTransactions({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FilterTransactionsState createState() => _FilterTransactionsState();
}

class _FilterTransactionsState extends State<FilterTransactions> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ApplicationStore appStore = getIt<ApplicationStore>();

  String? selectedQubicId;
  ComputedTransactionStatus? selectedStatus;
  TransactionDirection? selectedDirection;
  @override
  void initState() {
    super.initState();

    if (appStore.transactionFilter!.qubicId != null) {
      selectedQubicId = appStore.transactionFilter!.qubicId!;
    }

    if (appStore.transactionFilter!.status != null) {
      selectedStatus = appStore.transactionFilter!.status!;
    }

    if (appStore.transactionFilter!.direction != null) {
      selectedDirection = appStore.transactionFilter!.direction!;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> getStatusLabel(ComputedTransactionStatus? e) {
    List<Widget> out = [];
    if (e == null) {
      out.add(const Icon(Icons.clear));
      out.add(Text(
        "Any status",
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontStyle: FontStyle.italic),
      ));
    } else {
      out.add(Icon(getTransactionStatusIcon(e)));
      out.add(const Text(" "));
      out.add(Text(getTransactionStatusText(e)));
    }
    return out;
  }

  List<Widget> getDirectionLabel(TransactionDirection? e) {
    List<Widget> out = [];
    if (e == null) {
      out.add(const Icon(Icons.clear));
      out.add(Text(
        "Any direction",
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
          labelText: 'By direction',
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

  Widget getStatusDropdown() {
    List<ComputedTransactionStatus?> statusOptions = [
      null,
      ComputedTransactionStatus.pending,
      ComputedTransactionStatus.confirmed,
      ComputedTransactionStatus.success,
      ComputedTransactionStatus.failure,
      ComputedTransactionStatus.invalid,
    ];

    List<DropdownMenuItem> items = statusOptions
        .map((e) => DropdownMenuItem<ComputedTransactionStatus?>(
            value: e,
            child: Column(
                children: [Row(children: getStatusLabel(e)), const Divider()])))
        .toList();

    return FormBuilderDropdown(
        name: "status",
        icon: SizedBox(height: 2, child: Container()),
        onChanged: (value) {
          setState(() {
            selectedStatus = value;
          });
        },
        initialValue: selectedStatus,
        decoration: InputDecoration(
          labelText: 'By Status',
          suffix: selectedStatus == null
              ? const SizedBox(height: 10)
              : SizedBox(
                  height: 25,
                  width: 25,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.close, size: 15.0),
                    onPressed: () {
                      _formKey.currentState!.fields['status']?.didChange(null);
                      setState(() {
                        selectedStatus = null;
                      });
                      // _formKey.currentState!.fields['status']?.setState(() {
                      //   _formKey.currentState!.fields['status']?.didChange(null);
                      // });
                    },
                  )),
          hintText: 'By Status',
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
                      ? getStatusLabel(item.value)
                      : [
                          Text(
                            "Any status",
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

  Widget getAccountsDropdown() {
    List<QubicListVm?> accounts = [];
    accounts.add(null);
    accounts.addAll(appStore.currentQubicIDs);

    List<DropdownMenuItem<String?>> selectableItems = [];
    selectableItems.add(DropdownMenuItem<String?>(
        value: null,
        child: Column(children: [
          Row(children: [
            const Icon(Icons.clear),
            Text(
              "Any Qubic ID",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontStyle: FontStyle.italic),
            ),
          ]),
          const Divider(),
        ])));
    selectableItems.addAll(appStore.currentQubicIDs
        .map((e) => DropdownMenuItem<String?>(
            value: e.publicId,
            child: Column(children: [
              IdListItemSelect(item: e, showAmount: false),
              const Divider()
            ])))
        .toList());

    return FormBuilderDropdown(
        name: "qubicId",
        icon: SizedBox(height: 2, child: Container()),
        onChanged: (value) {
          setState(() {
            selectedQubicId = value;
          });
        },
        initialValue: selectedQubicId,
        decoration: InputDecoration(
          labelText: 'By Qubic ID',
          suffix: selectedQubicId == null
              ? const SizedBox(height: 12)
              : SizedBox(
                  height: 25,
                  width: 25,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.close, size: 15.0),
                    onPressed: () {
                      _formKey.currentState!.fields['qubicId']?.didChange(null);
                      setState(() {
                        selectedQubicId = null;
                      });
                    },
                  )),
          hintText: 'By Qubic ID',
        ),
        selectedItemBuilder: (BuildContext context) {
          return accounts.map<Widget>((QubicListVm? item) {
            // This is the widget that will be shown when you select an item.
            // Here custom text style, alignment and layout size can be applied
            // to selected item string.

            if (item == null) {
              return Text("Any Qubic ID",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontStyle: FontStyle.italic));
            }
            return Container(
                alignment: Alignment.centerLeft,
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(child: Text("${item.name} - ")),
                    Expanded(
                        child: Text(
                      item.publicId,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ],
                ));
          }).toList();
        },
        items: selectableItems);
  }

  Widget getScrollView() {
    return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Row(children: [
          Container(
              child: Expanded(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Filter transactions",
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontFamily: ThemeFonts.primary)),
              appStore.transactionFilter!.totalActiveFilters > 0
                  ? TextButton(
                      onPressed: () {
                        appStore.clearTransactionFilters();
                        Navigator.pop(context);
                      },
                      child: Text("Clear All",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .titleSmall
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary)))
                  : Container(),
              Padding(
                  padding:
                      const EdgeInsets.only(top: ThemePaddings.normalPadding),
                  child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          getAccountsDropdown(),
                          const SizedBox(height: ThemePaddings.normalPadding),
                          selectedQubicId != null
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: ThemePaddings.hugePadding),
                                  child: getDirectionDropdown())
                              : Container(),
                          const SizedBox(height: ThemePaddings.normalPadding),
                          getStatusDropdown(),
                        ],
                      )))
            ],
          )))
        ]));
  }

  List<Widget> getButtons() {
    return [
      !isLoading
          ? TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("CANCEL",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      )))
          : Container(),
      FilledButton(
          onPressed: saveIdHandler, child: const Text("PROCEED WITH FILTERS"))
    ];
  }

  void saveIdHandler() async {
    _formKey.currentState?.validate();
    if (!_formKey.currentState!.isValid) {
      return;
    }

    //Prevent duplicates
    appStore.setTransactionFilters(
        selectedQubicId, selectedStatus, selectedDirection);

    Navigator.pop(context);
  }

  TextEditingController privateSeed = TextEditingController();

  bool showAccountInfoTooltip = false;
  bool showSeedInfoTooltip = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(!isLoading);
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: SafeArea(
                minimum: const EdgeInsets.fromLTRB(ThemePaddings.normalPadding,
                    0, ThemePaddings.normalPadding, ThemePaddings.miniPadding),
                child: Column(children: [
                  Expanded(child: getScrollView()),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: getButtons())
                ]))));
  }
}
