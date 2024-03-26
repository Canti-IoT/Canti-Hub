import 'package:canti_hub/pages/parameters_page/detail_widget.dart';
import 'package:canti_hub/providers/parameters_provicer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:canti_hub/pages/common/custom_app_bar.dart';

import 'package:provider/provider.dart'; // Import provider package

class ParametersPage extends StatelessWidget {
  const ParametersPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    var parametersProvider = context.watch<ParametersProvider>();

    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.arrow_back,
        title: localisation!.parameters_configuration,
        onLeftIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: ListView(
        children: parametersProvider.parameters.map((parameter) {
          return DetailWidget(
            parameter: parameter,
          );
        }).toList(),
      ),
    );
  }
}
