import 'package:canti_hub/pages/nested_settings_page/detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:flutter_octicons/flutter_octicons.dart';

class NestedSettingsPage extends StatelessWidget {
  final String pageTitle;
  final String pageType; // Add this variable to identify page type

  const NestedSettingsPage({
    Key? key,
    required this.pageTitle,
    required this.pageType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.arrow_back,
        title: pageTitle, // Use the provided pageTitle for the app bar title
        onLeftIconPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
          print('here');
        },
      ),
      body: ListView(
        children: [
          DetailWidget(
            title: 'Title 1',
          ),
          DetailWidget(
            title: 'Title 2',
            showToggle: true,
            toggleValue: true,
            onToggleChanged: () {
              // Handle toggle change
            },
          ),
          DetailWidget(
            title: 'Title 3',
            onRemovePressed: () {
              // Handle remove action
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle the "+" button press
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
