import 'package:flutter/material.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/re_auth_dialog.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/reveal_seed/reveal_seed_contents.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/reveal_seed/reveal_seed_warning.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/styles/edgeInsets.dart';

class RevealSeed extends StatefulWidget {
  final QubicListVm item;
  const RevealSeed({super.key, required this.item});

  @override
  // ignore: library_private_types_in_public_api
  _RevealSeedState createState() => _RevealSeedState();
}

class _RevealSeedState extends State<RevealSeed> {
  final ApplicationStore appStore = getIt<ApplicationStore>();

  bool hasAccepted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getContents() {
    return RevealSeedContents(item: widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
            minimum: ThemeEdgeInsets.pageInsets,
            child: Column(children: [Expanded(child: getContents())])));
  }
}
