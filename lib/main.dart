import 'package:canti_hub/background_task_handler.dart';
import 'package:canti_hub/pages/start_page.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:canti_hub/providers/device_provider.dart';
import 'package:canti_hub/providers/parameters_provicer.dart';
import 'package:canti_hub/providers/settings_provider.dart';
import 'package:canti_hub/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'foreground_service',
      channelName: 'Foreground Service Notification',
      channelDescription:
          'This notification appears when the foreground service is running.',
      channelImportance: NotificationChannelImportance.LOW,
      priority: NotificationPriority.LOW,
      iconData: const NotificationIconData(
        resType: ResourceType.mipmap,
        resPrefix: ResourcePrefix.ic,
        name: 'launcher',
      ),
      buttons: [
        const NotificationButton(id: 'sendButton', text: 'Send'),
        const NotificationButton(
          id: 'testButton',
          text: 'Test',
          textColor: Colors.orange,
        ),
      ],
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: const ForegroundTaskOptions(
      interval: 3000,
      isOnceEvent: false,
      autoRunOnBoot: true,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );
  requestBluetoothPermissions();
  startForegroundTask();
  runApp(const App());
}

// Function to start the foreground task
void startForegroundTask() {
  FlutterForegroundTask.startService(
    notificationTitle: 'Foreground Service is ',
    notificationText: 'Tap to  to the app',
    callback: startCallback,
  );
}

// Callback function for the foreground task
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(BackgroundTaskHandler());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // this will listen for events
    FlutterForegroundTask.receivePort?.listen((data) {
      print('eventCount: ${data.toString()}');
    });
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ParametersProvider()),
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => DeviceProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return WithForegroundTask(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Canti Hub',
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: themeProvider.getLightTheme,
              darkTheme: themeProvider.getDarkTheme,
              themeMode: themeProvider.getThemeMode,
              home: const StartPage(),
            ),
          );
        },
      ),
    );
  }
}

// Function to request Bluetooth permissions
void requestBluetoothPermissions() {
  Permission.bluetooth.request();
  Permission.bluetoothScan.request();
  Permission.bluetoothConnect.request();
  Permission.notification.request();
}
