import 'package:canti_hub/pages/main_page/pages/add_device_page/widgets/device_widget.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:canti_hub/providers/bluetooth_provider.dart';
import 'package:provider/provider.dart';

class AddBluetoothDeviceWidgets extends StatefulWidget {
  final BuildContext context;

  const AddBluetoothDeviceWidgets({Key? key, required this.context})
      : super(key: key);

  @override
  _AddBluetoothDeviceWidgetsState createState() =>
      _AddBluetoothDeviceWidgetsState();
}

class _AddBluetoothDeviceWidgetsState extends State<AddBluetoothDeviceWidgets> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<BluetoothProvider>().turnOn();
      context.read<BluetoothProvider>().startListentingToScanResults();
      context.read<BluetoothProvider>().startScaning();
    });
    // Add initialization code here
  }

  @override
  void dispose() {
    context.read<BluetoothProvider>().stopListentingToScanResults();
    context.read<BluetoothProvider>().stopScaning();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('System Devices:'),
        ...context
            .watch<BluetoothProvider>()
            .systemDevices
            .where((device) => !context
                .watch<DatabaseProvider>()
                .devices
                .any((element) => element.remoteId == device.remoteId.str))
            .map((device) => DeviceWidget(device: device)),
        Text('Scan Devices:'),
        ...context
            .watch<BluetoothProvider>()
            .scanResults
            .where((result) => !context.watch<DatabaseProvider>().devices.any(
                (element) => element.remoteId == result.device.remoteId.str))
            .map((result) => DeviceWidget(device: result.device)),
      ],
    );
  }
}
