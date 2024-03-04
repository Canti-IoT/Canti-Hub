import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:canti_hub/pages/common/settings_type.dart';
import 'package:canti_hub/pages/main_page/devices_list.dart';
import 'package:canti_hub/pages/nested_settings_page/nested_settings_page.dart';
import 'package:canti_hub/pages/settings_page/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
          leftIcon: Icons.settings,
          onLeftIconPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
          rightIcon: Icons.notifications_none,
          onRightIconPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NestedSettingsPage(
                      pageTitle: localisation!.alarms,
                      pageType: SettingsType.alarms)),
            );
          }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horizontal scrollable list of avatars
          Container(
            margin: const EdgeInsets.only(left: 16, top: 16),
            child: Text(
              localisation!.devices,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const DevicesList(),

          // Placeholder for the heatmap or any other content
          Container(
            margin: const EdgeInsets.all(16),
            child: const Text(
              'Placeholder for Heatmap or other content',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
