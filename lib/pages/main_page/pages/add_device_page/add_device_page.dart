import 'package:canti_hub/database/custom_types.dart';
import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:canti_hub/pages/main_page/pages/add_device_page/add_mqtt_device_widgets.dart';
import 'package:canti_hub/pages/main_page/pages/add_device_page/widgets/device_name_widget.dart';
import 'package:canti_hub/pages/main_page/pages/add_device_page/widgets/device_type_widget.dart';
import 'package:canti_hub/providers/bluetooth_provider.dart';
import 'package:canti_hub/providers/device_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'add_bluetooth_device_widgets.dart';

class AddDevicePage extends StatelessWidget {
  AddDevicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    // context.read<BleScanner>().startScan([
    //   Uuid.parse(
    //       "4fafc201-1fb5-459e-8fcc-c5c9c331914b"), // Parameter Index Service
    //   Uuid.parse(
    //       "f35d596b-fff1-466d-97d8-ba175cd0a674"), // Parameter Value Service
    //   Uuid.parse(
    //       "cc944d76-a6b6-4a01-b7f8-77b02967f31f"), // Configuration service
    // ]);

    // var scannerState = context.watch<BleScannerState>();

    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.arrow_back,
        title: localisation!.add_device,
        onLeftIconPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 80.0),
        children: [
          DeviceNameWidget(),
          DeviceTypeWidget(),
          // Use the Bluetooth widget group
          if(context.watch<DeviceProvider>().deviceType ==
              DeviceType.bluetooth)
          AddBluetoothDeviceWidgets(context: context),
          // Use the MQTT widget group
          AddMqttDeviceWidgets(),
          // Add other common widgets for both Bluetooth and MQTT devices here
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: FloatingActionButton.extended(
              heroTag: "cancel",
              onPressed: () {
                // Do nothing for delete button tap
              },
              icon: Icon(Icons.cancel),
              label: Text(
                localisation!.cancel,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          if (context.watch<DeviceProvider>().deviceType ==
              DeviceType.bluetooth)
            Spacer(),
          if (context.watch<DeviceProvider>().deviceType ==
              DeviceType.bluetooth)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  context.read<BluetoothProvider>().refresh();
                },
                child: Icon(Icons.refresh),
              ),
            ),
          SizedBox(width: 16.0),
          FloatingActionButton.extended(
            heroTag: "add parameter",
            onPressed: () {
              context.read<DeviceProvider>().save(context);
            },
            icon: Icon(Icons.add),
            label: Text(
              localisation!.add,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
