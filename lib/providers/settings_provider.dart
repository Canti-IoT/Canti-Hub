import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ParametersDisplayMode { list, grid_1, grid_2, grid_3 }

class SettingsProvider extends ChangeNotifier {
  late bool _checkAppUpdate = false;
  late bool _checkFirmwareUpdate = false;
  late bool _systemTheme = true;
  late bool _darkTheme = false;
  ParametersDisplayMode _displayMode = ParametersDisplayMode.grid_2;

  static const String _checkAppUpdateKey = 'checkAppUpdate';
  static const String _checkFirmwareUpdateKey = 'checkFirmwareUpdate';
  static const String _systemThemeKey = 'systemTheme';
  static const String _darkThemeKey = 'darkTheme';
  static const String _displayModeKey = 'displayMode';

  // Load settings from local storage (SharedPreferences)
  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load settings if they exist, otherwise, keep the default values
    _checkAppUpdate = prefs.getBool(_checkAppUpdateKey) ?? false;
    _checkFirmwareUpdate = prefs.getBool(_checkFirmwareUpdateKey) ?? false;
    _systemTheme = prefs.getBool(_systemThemeKey) ?? true;
    _darkTheme = prefs.getBool(_darkThemeKey) ?? false;
    _displayMode = ParametersDisplayMode.values[
        prefs.getInt(_displayModeKey) ?? ParametersDisplayMode.grid_2.index];

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

  ParametersDisplayMode get displayMode => _displayMode;
  set displayMode(ParametersDisplayMode newValue) {
    if (_displayMode != newValue) {
      _displayMode = newValue;
      _saveToSharedPreferences(_displayModeKey, newValue.index);
      notifyListeners();
    }
  }

  Future<void> _saveToSharedPreferences(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    }
  }
}
