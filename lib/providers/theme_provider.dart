import 'package:canti_hub/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeData _lightTheme;
  late ThemeData _darkTheme;
  late ThemeMode _themeMode;

  ThemeProvider() {
    _lightTheme = ThemeData.light();
    _darkTheme = ThemeData.dark();
    _themeMode = ThemeMode.system;
  }

  ThemeData get getLightTheme => _lightTheme;
  ThemeData get getDarkTheme => _darkTheme;
  ThemeMode get getThemeMode => _themeMode;

  void loadTheme(BuildContext context) async {
    bool systemTheme = context.read<SettingsProvider>().systemTheme;
    bool darkTheme = context.read<SettingsProvider>().darkTheme;

    if (systemTheme) {
      _themeMode = ThemeMode.system;
    } else {
      if (darkTheme) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    }
    notifyListeners();
  }
}
