import 'package:canti_hub/pages/start_page.dart';
import 'package:canti_hub/providers/bluetooth_provider.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:canti_hub/providers/device_provider.dart';
import 'package:canti_hub/providers/parameters_provicer.dart';
import 'package:canti_hub/providers/settings_provider.dart';
import 'package:canti_hub/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  requestAppPermissions();
  runApp(App());
}

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParametersProvider()),
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
        ChangeNotifierProvider(create: (_) => BluetoothProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Canti Hub',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: themeProvider.getLightTheme,
            darkTheme: themeProvider.getDarkTheme,
            themeMode: themeProvider.getThemeMode,
            home: const StartPage(),
          );
        },
      ),
    );
  }
}

// Function to request necessary permissions
void requestAppPermissions() {
  Permission.bluetooth.request();
  Permission.bluetoothScan.request();
  Permission.bluetoothConnect.request();
  Permission.notification.request();
//   Permission.systemAlertWindow.request();
//   Permission.ignoreBatteryOptimizations.request();
}
