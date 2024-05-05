import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DeviceSettings extends StatelessWidget {
  const DeviceSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);
    var index = context.watch<DatabaseProvider>().selectedDeviceIndex;
    var device;
    if (index != null) {
      device = context.watch<DatabaseProvider>().devices[index];
    }
    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.arrow_back,
        title: '${device.displayNmae}',
        onLeftIconPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
      body: device != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Device Name: ${device.name}'),
                Text('Device Type: ${device.type.toString().split('.').last}'),
                Text('Device ID: ${device.id}'),
                Text('Remote ID: ${device.remoteId}'),
                Text('Display Name: ${device.displayNmae}'),
                Text('Software Version: ${device.softwareVersion}'),
                Text('Hardware Version: ${device.hardwareVersion}'),
                Text(
                    'First connection: ${device.firstConnection.toIso8601String()}'),
                Text('Last online: ${device.lastOnline.toIso8601String()}'),
                // Add more Text widgets for other device properties as needed
              ],
            )
          : Container(),
    );
  }
}