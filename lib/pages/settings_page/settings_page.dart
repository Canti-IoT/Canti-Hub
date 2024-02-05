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
          Navigator.popUntil(context, (route) => route.isFirst);
          print('here');
        },
      ),
      body: ListView(
        children: [
          WebLinkSetting(
              icon: OctIcons.mark_github_16,
              label: localisation.settings_github,
              url: localisation.settings_github_url),
          ToggleSetting(label: localisation.settings_app_update, initialValue: true),
          ToggleSetting(label: localisation.settings_firmware_update, initialValue: true),
          NestedSetting(
              label: localisation.settings_default_recurrence, page: SettingsPage()),
          NestedSetting(label: localisation.settings_wifi, page: SettingsPage()),
          NestedSetting(label: localisation.settings_mqtt, page: SettingsPage()),
        ],
      ),
    );
  }
}
