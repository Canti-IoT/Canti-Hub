import 'package:canti_hub/pages/start_page.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:canti_hub/providers/parameters_provicer.dart';
import 'package:canti_hub/providers/settings_provider.dart';
import 'package:canti_hub/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ParametersProvider()),
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
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
