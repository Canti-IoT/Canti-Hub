import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:canti_hub/pages/main_page/pages/detail_page/parameter_widget.dart';
import 'package:canti_hub/pages/main_page/widgets/bluetooth_adapter_state_widget.dart';
import 'package:canti_hub/pages/main_page/widgets/devices_list.dart';
import 'package:canti_hub/pages/settings_page/pages/alarms_page/alarms_page.dart';
import 'package:canti_hub/pages/settings_page/settings_page.dart';
import 'package:canti_hub/providers/bluetooth_provider.dart';
import 'package:canti_hub/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<BluetoothProvider>().startListentingToAdapterState());
  }

  @override
  void dispose() {
    context.read<BluetoothProvider>().stopListentingToAdapterState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
          leftIcon: Icons.settings,
          onLeftIconPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
          rightIcon: Icons.notifications_none,
          onRightIconPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AlarmsPage()),
            );
          }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horizontal scrollable list of avatars
          Container(
            margin: const EdgeInsets.only(left: 16, top: 16),
            child: Text(
              localisation!.devices,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (context.watch<BluetoothProvider>().adapterState !=
              BluetoothAdapterState.on)
            BluetoothAdapterStateWidget(),

          DevicesList(),

          // Placeholder for the heatmap or any other content
          Expanded(
            child: Container(
              child: GridView.count(
                childAspectRatio:
                    context.watch<SettingsProvider>().displayMode.index == 0
                        ? 4
                        : 1,
                crossAxisCount:
                    context.watch<SettingsProvider>().displayMode.index > 0
                        ? context.watch<SettingsProvider>().displayMode.index
                        : 1,
                padding: EdgeInsets.all(16.0),
                children: [
                  // Add ParameterWidget instances for different parameters
                  ParameterWidget(
                    parameterName: 'Temperature',
                    value: 26.0, // Replace with actual value
                    desiredValue: 21.0,
                    unit: '°C',
                  ),
                  ParameterWidget(
                    parameterName: 'Humidity',
                    value: 50.0, // Replace with actual value
                    desiredValue: 50.0,
                    unit: '%',
                  ),
                  ParameterWidget(
                    parameterName: 'Air Quality(VOCs)',
                    value: 0.6, // Replace with actual value
                    desiredValue: 1.0,
                    unit: '%',
                  ),
                  ParameterWidget(
                    parameterName: 'Pressure',
                    value: 1000.0, // Replace with actual value
                    desiredValue: 1010.0,
                    unit: 'Pa',
                  ),
                  ParameterWidget(
                    parameterName: 'Noise Level',
                    value: 30.0, // Replace with actual value
                    desiredValue: 1.0,
                    unit: 'dB',
                  ),
                  ParameterWidget(
                    parameterName: 'Light Level',
                    value: 500.0, // Replace with actual value
                    desiredValue: 50.0,
                    unit: 'lux',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}