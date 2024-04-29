import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:canti_hub/pages/main_page/pages/detail_page/parameter_widget.dart';
import 'package:canti_hub/pages/main_page/widgets/bluetooth_adapter_state_widget.dart';
import 'package:canti_hub/pages/main_page/widgets/devices_list.dart';
import 'package:canti_hub/pages/settings_page/pages/alarms_page/alarms_page.dart';
import 'package:canti_hub/pages/settings_page/settings_page.dart';
import 'package:canti_hub/providers/bluetooth_provider.dart';
import 'package:canti_hub/providers/database_provider.dart';
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
    var deviceParameters = context.watch<DatabaseProvider>().deviceParameters;
    var selectedDeviceIndex =
        context.watch<DatabaseProvider>().selectedDeviceIndex;
    var devices = context.watch<DatabaseProvider>().devices;
    var selectedDevice = null;
    if (selectedDeviceIndex < devices.length) {
      selectedDevice =
          context.watch<DatabaseProvider>().devices[selectedDeviceIndex];
    }
    print("Parameters: ${deviceParameters.toString()}");
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
                children: deviceParameters
                    .where((element) => element.deviceId == selectedDevice!.id)
                    .map((param) {
                  var parameter = context
                      .watch<DatabaseProvider>()
                      .getParameterByIndex(param!.parameterId);
                  return ParameterWidget(
                    parameterName: parameter!.name,
                    value: 0.0,
                    desiredValue: parameter!.normal,
                    unit: parameter!.units,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
