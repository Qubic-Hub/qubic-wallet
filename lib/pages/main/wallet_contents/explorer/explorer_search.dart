import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:qubic_wallet/components/explorer_results/explorer_result_qubic_id.dart';
import 'package:qubic_wallet/components/explorer_results/explorer_result_tick.dart';
import 'package:qubic_wallet/components/explorer_results/explorer_result_transaction.dart';

import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/explorer_query_dto.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/resources/qubic_li.dart';
import 'package:qubic_wallet/stores/explorer_store.dart';

class ExplorerSearch extends StatefulWidget {
  const ExplorerSearch({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExplorerSearchState createState() => _ExplorerSearchState();
}

class _ExplorerSearchState extends State<ExplorerSearch> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ExplorerStore explorerStore = getIt<ExplorerStore>();
  final QubicLi qubicLi = getIt<QubicLi>();

  List<ExplorerQueryDto>? searchResults;
  String lastSearchQuery = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> getItems() {
    List<Widget> items = [];
    for (var item in searchResults!) {
      items.add(Container(
          padding: const EdgeInsets.all(ThemePaddings.miniPadding),
          child: Column(children: [
            item.type == ExplorerResult.publicId
                ? ExplorerResultQubicId(item: item)
                : item.type == ExplorerResult.tick
                    ? ExplorerResultTick(item: item)
                    : ExplorerResultTransaction(item: item)
          ])));
    }
    return items;
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
                Text("Explorer search",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontFamily: ThemeFonts.primary)),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(top: ThemePaddings.normalPadding),
                    child: FormBuilder(
                        key: _formKey,
                        child: Column(children: [
                          FormBuilderTextField(
                            name: "searchTerm",
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            maxLines: 2,
                            readOnly: isLoading,
                            decoration: InputDecoration(
                                labelText: 'Tick / TX ID / Public ID',
                                suffix: SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        icon: const Icon(Icons.clear, size: 18),
                                        onPressed: () {
                                          _formKey.currentState!
                                              .fields["searchTerm"]!
                                              .didChange(null);
                                        }))),
                            autocorrect: false,
                            autofillHints: null,
                          ),
                        ]))),
                searchResults == null ? Container() : const Divider(),
                const SizedBox(height: ThemePaddings.smallPadding),
                Builder(builder: (context) {
                  if (searchResults == null) {
                    return Container();
                  }
                  if (searchResults!.isEmpty) {
                    return SizedBox(
                        width: double.infinity,
                        child: Column(children: [
                          const Text("No results found matching:",
                              textAlign: TextAlign.center),
                          Text(lastSearchQuery, textAlign: TextAlign.center)
                        ]));
                  }

                  return Container(
                      child: Column(children: [
                    Text(
                      "Found ${searchResults!.length} result${searchResults!.length > 1 ? "s" : ""}",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: ThemePaddings.smallPadding),
                    Column(children: getItems())
                  ]));
                })
              ])))
        ]));
  }

  List<Widget> getButtons() {
    return [
      !isLoading
          ? TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("BACK",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      )))
          : Container(),
      FilledButton(
          onPressed: searchHandler,
          child: isLoading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.onPrimary)))
              : const Text("SEARCH"))
    ];
  }

  void searchHandler() async {
    _formKey.currentState?.validate();
    if (!_formKey.currentState!.isValid) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    List<ExplorerQueryDto>? result = await qubicLi.getExplorerQuery(
        _formKey.currentState!.fields["searchTerm"]!.value as String);
    setState(() {
      lastSearchQuery =
          _formKey.currentState!.fields["searchTerm"]!.value as String;
      searchResults = result;
      isLoading = false;
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  TextEditingController privateSeed = TextEditingController();

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
