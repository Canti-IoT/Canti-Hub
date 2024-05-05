import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
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
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text('Device Information', style: TextStyle(fontWeight: FontWeight.bold)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Device Name: ${device.name}'),
                          Text('Device Type: ${device.type.toString().split('.').last}'),
                          Text('Device ID: ${device.remoteId}'),
                          Text('Software Version: ${device.softwareVersion}'),
                          Text('Hardware Version: ${device.hardwareVersion}'),
                          Text(
                              'First connection: ${DateFormat('HH:mm:ss dd/MM/yyyy').format(device.firstConnection)}'),
                          Text('Last online: ${DateFormat('HH:mm:ss dd/MM/yyyy').format(device.lastOnline)}'),
                        ],
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text('Apply default parameter configuration', style: TextStyle(fontWeight: FontWeight.bold)),
                  children: <Widget>[
                    CheckboxListTile(
                      value: true, // Example value
                      onChanged: (bool? value) {},
                      title: Text('Option 1'),
                    ),
                    CheckboxListTile(
                      value: false, // Example value
                      onChanged: (bool? value) {},
                      title: Text('Option 2'),
                    ),
                    // Add more CheckboxListTile widgets as needed
                  ],
                ),
              ],
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if( device != null)
          {
            print("Deleting device");
            await context.read<DatabaseProvider>().deleteDevice(device);
            Navigator.of(context).pop();
          }
        },
        icon: Icon(Icons.delete),
        label: Text('Delete Device'),
      ),
    );
  }
}
