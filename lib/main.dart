import 'package:canti_hub/pages/start_page.dart';
import 'package:canti_hub/providers/parameters_provicer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart'; // for seting localization deletages, and suported locales

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ParametersProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Canti Hub',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StartPage(),
      ),
    );
  }
}
