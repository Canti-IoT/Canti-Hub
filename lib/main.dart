import 'dart:async';

import 'package:canti_hub/ble/ble_device_connector.dart';
import 'package:canti_hub/ble/ble_device_interactor.dart';
import 'package:canti_hub/ble/ble_logger.dart';
import 'package:canti_hub/ble/ble_scanner.dart';
import 'package:canti_hub/ble/ble_status_monitor.dart';
import 'package:canti_hub/pages/start_page.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:canti_hub/providers/device_provider.dart';
import 'package:canti_hub/providers/parameters_provicer.dart';
import 'package:canti_hub/providers/settings_provider.dart';
import 'package:canti_hub/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  requestAppPermissions();

  final bleLogger = BleLogger();
  final ble = FlutterReactiveBle();
  final scanner = BleScanner(ble: ble, logMessage: bleLogger.addToLog);
  final monitor = BleStatusMonitor(ble);
  final connector =
      BleDeviceConnector(ble: ble, logMessage: bleLogger.addToLog);
  final serviceDiscoverer = BleDeviceInteractor(
    // ignore: deprecated_member_use
    bleDiscoverServices: ble.discoverServices,
    readCharacteristic: ble.readCharacteristic,
    writeWithResponse: ble.writeCharacteristicWithResponse,
    writeWithOutResponse: ble.writeCharacteristicWithoutResponse,
    subscribeToCharacteristic: ble.subscribeToCharacteristic,
    logMessage: bleLogger.addToLog,
  );

  runApp(App(
    bleLogger: bleLogger,
    ble: ble,
    scanner: scanner,
    monitor: monitor,
    connector: connector,
    serviceDiscoverer: serviceDiscoverer,
  ));
}

class App extends StatelessWidget {
  final BleLogger bleLogger;
  final FlutterReactiveBle ble;
  final BleScanner scanner;
  final BleStatusMonitor monitor;
  final BleDeviceConnector connector;
  final BleDeviceInteractor serviceDiscoverer;

  const App({
    Key? key,
    required this.bleLogger,
    required this.ble,
    required this.scanner,
    required this.monitor,
    required this.connector,
    required this.serviceDiscoverer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: scanner),
        Provider.value(value: monitor),
        Provider.value(value: connector),
        Provider.value(value: serviceDiscoverer),
        Provider.value(value: bleLogger),
        StreamProvider<BleScannerState?>(
          create: (_) => scanner.state,
          initialData: const BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
        ),
        StreamProvider<BleStatus?>(
          create: (_) => monitor.state,
          initialData: BleStatus.unknown,
        ),
        StreamProvider<ConnectionStateUpdate>(
          create: (_) => connector.state,
          initialData: const ConnectionStateUpdate(
            deviceId: 'Unknown device',
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          ),
        ),
        ChangeNotifierProvider(create: (_) => ParametersProvider()),
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
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
