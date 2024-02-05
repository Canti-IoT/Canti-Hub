import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:canti_hub/pages/settings_page/settings_widgets/nested_setting.dart';
import 'package:canti_hub/pages/settings_page/settings_widgets/toggle_setting.dart';
import 'package:canti_hub/pages/settings_page/settings_widgets/web_link_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_octicons/flutter_octicons.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.arrow_back,
        title: localisation!.settings,
        onLeftIconPressed: () {
          print('here');
        },
      ),
      body: ListView(
        children: [
          WebLinkSetting(icon: OctIcons.mark_github_16, label: 'GitHub Page', url: 'https://github.com/CatalinPlesu'),
          ToggleSetting(label: 'Check for app update', initialValue: true),
          ToggleSetting(label: 'Check for firmware update', initialValue: true),
          NestedSetting(label: 'Configure default recurrences', page: SettingsPage()),
          NestedSetting(label: 'Wi-Fi Settings', page: SettingsPage()),
          NestedSetting(label: 'MQTT Settings', page: SettingsPage()),
        ],
      ),
    );
  }
}
