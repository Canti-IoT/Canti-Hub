import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  late bool _checkAppUpdate;
  late bool _checkFirmwareUpdate;
  late bool _systemTheme;
  late bool _darkTheme;

  static const String _checkAppUpdateKey = 'checkAppUpdate';
  static const String _checkFirmwareUpdateKey = 'checkFirmwareUpdate';
  static const String _systemThemeKey = 'systemTheme';
  static const String _darkThemeKey = 'darkTheme';

  // Load settings from local storage (SharedPreferences)
  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load settings if they exist, otherwise, keep the default values
    _checkAppUpdate = prefs.getBool(_checkAppUpdateKey) ?? false;
    _checkFirmwareUpdate = prefs.getBool(_checkFirmwareUpdateKey) ?? false;
    _systemTheme = prefs.getBool(_systemThemeKey) ?? true;
    _darkTheme = prefs.getBool(_darkThemeKey) ?? false;

    // Notify listeners after loading settings
    notifyListeners();
  }

  bool get checkAppUpdate => _checkAppUpdate;
  set checkAppUpdate(bool newValue) {
    if (_checkAppUpdate != newValue) {
      _checkAppUpdate = newValue;
      _saveToSharedPreferences(_checkAppUpdateKey, newValue);
      notifyListeners();
    }
  }

  bool get checkFirmwareUpdate => _checkFirmwareUpdate;
  set checkFirmwareUpdate(bool newValue) {
    if (_checkFirmwareUpdate != newValue) {
      _checkFirmwareUpdate = newValue;
      _saveToSharedPreferences(_checkFirmwareUpdateKey, newValue);
      notifyListeners();
    }
  }

  bool get systemTheme => _systemTheme;
  set systemTheme(bool newValue) {
    if (_systemTheme != newValue) {
      _systemTheme = newValue;
      _saveToSharedPreferences(_systemThemeKey, newValue);
      notifyListeners();
    }
  }

  bool get darkTheme => _darkTheme;
  set darkTheme(bool newValue) {
    if (_darkTheme != newValue) {
      _darkTheme = newValue;
      _saveToSharedPreferences(_darkThemeKey, newValue);
      notifyListeners();
    }
  }

  Future<void> _saveToSharedPreferences(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }
}
