import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:canti_hub/pages/settings_page/pages/mqtt_page/mqtt_page.dart';
import 'package:canti_hub/pages/settings_page/pages/parameters_page/parameters_page.dart';
import 'package:canti_hub/pages/settings_page/pages/wifi_page/wifi_page.dart';
import 'package:canti_hub/pages/settings_page/widgets/nested_setting.dart';
import 'package:canti_hub/pages/settings_page/widgets/toggle_setting.dart';
import 'package:canti_hub/pages/settings_page/widgets/web_link_setting.dart';
import 'package:canti_hub/providers/settings_provider.dart';
import 'package:canti_hub/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:provider/provider.dart';

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
          ToggleSetting(
            label: localisation.settings_app_update,
            initialValue: context.watch<SettingsProvider>().checkAppUpdate,
            updateValue: (newValue) {
              context.read<SettingsProvider>().checkAppUpdate = newValue;
            },
          ),
          ToggleSetting(
            label: localisation.settings_firmware_update,
            initialValue: context.watch<SettingsProvider>().checkFirmwareUpdate,
            updateValue: (newValue) {
              context.read<SettingsProvider>().checkFirmwareUpdate = newValue;
            },
          ),
          ToggleSetting(
            label: localisation.settings_system_theme,
            initialValue: context.watch<SettingsProvider>().systemTheme,
            updateValue: (newValue) {
              context.read<SettingsProvider>().systemTheme = newValue;
              context.read<ThemeProvider>().loadTheme(context);
            },
          ),
          if (!context.watch<SettingsProvider>().systemTheme)
            ToggleSetting(
              label: localisation.settings_dark_theme,
              initialValue: context.watch<SettingsProvider>().darkTheme,
              updateValue: (newValue) {
                context.read<SettingsProvider>().darkTheme = newValue;
                context.read<ThemeProvider>().loadTheme(context);
              },
            ),
          NestedSetting(
              label: localisation.parameters_configuration,
              page: ParametersPage()),
          NestedSetting(
              label: localisation.settings_wifi, page: WifiSettingsPage()),
          NestedSetting(
              label: localisation.settings_mqtt, page: MqttSettingsPage()),
        ],
      ),
    );
  }
}
