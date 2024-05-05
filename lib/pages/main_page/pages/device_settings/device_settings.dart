import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:canti_hub/providers/bluetooth_provider.dart';
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
        title: device != null ? '${device.displayNmae}' : 'no device',
        onLeftIconPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
      body: device != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpansionTile(
                  initiallyExpanded: false,
                  title: Text('Device Information',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Device Name: ${device.name}'),
                          Text(
                              'Device Type: ${device.type.toString().split('.').last}'),
                          Text('Device ID: ${device.remoteId}'),
                          Text('Software Version: ${device.softwareVersion}'),
                          Text('Hardware Version: ${device.hardwareVersion}'),
                          Text(
                              'First connection: ${DateFormat('HH:mm:ss dd/MM/yyyy').format(device.firstConnection)}'),
                          Text(
                              'Last online: ${DateFormat('HH:mm:ss dd/MM/yyyy').format(device.lastOnline)}'),
                        ],
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  initiallyExpanded: false,
                  title: Text('Device Alarms',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  children: List<Widget>.generate(3, (i) {
                    var deviceAlarms =
                        context.watch<DatabaseProvider>().deviceAlarms;
                    DeviceAlarmsTableData? alarm;
                    try {
                      alarm = deviceAlarms.firstWhere((a) => a.slot == i + 1);
                    } catch (e) {}
                    var alarmName = alarm != null
                        ? context
                            .watch<DatabaseProvider>()
                            .alarms
                            .firstWhere((a) => a.id == alarm!.alarmId)
                            .name
                        : null;

                    return ListTile(
                      leading: Icon(alarm != null ? Icons.delete : Icons.add),
                      title: Text(alarm != null
                          ? 'Alarm Slot ${i + 1}: ${alarmName}'
                          : 'Alarm Slot ${i + 1}'),
                      onTap: () {
                        if (alarm != null) {
                          context.read<DatabaseProvider>().deleteDeviceAlarm(alarm);
                        } else {
                          _showAddAlarmDialog(context, i + 1, device.id);
                        }
                      },
                    );
                  }),
                ),
                ExpansionTile(
                  initiallyExpanded: false,
                  title: Text('Apply parameter configuration',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  children: context.watch<DatabaseProvider>().deviceParameters
                      .map<Widget>((deviceParam) {
                        var parameter = context.watch<DatabaseProvider>()
                            .getParameterByIndex(deviceParam.parameterId);
                        return CheckboxListTile(
                          value: deviceParam.useUserConfig,
                          onChanged: (bool? value) {
                            // Update the useUserConfig in the database
                            context.read<DatabaseProvider>().updateDeviceParameter(
                              deviceParam.copyWith(useUserConfig: value),
                            );
                          },
                          title: Text(parameter?.name ?? 'Unknown Parameter'),
                        );
                      }).toList(),
                ),
              ],
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (device != null) {
            print("Deleting device");
            context.read<BluetoothProvider>().stopListeningToAdapterState();
            await context.read<DatabaseProvider>().deleteDevice(device);
            Navigator.of(context).pop();
          }
        },
        icon: Icon(Icons.delete),
        label: Text('Delete Device'),
      ),
    );
  }

  void _showAddAlarmDialog(BuildContext context, int slot, int deviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var alarms =
            Provider.of<DatabaseProvider>(context, listen: false).alarms;
        return AlertDialog(
          title: Text('Select an Alarm'),
          content: SingleChildScrollView(
            child: ListBody(
              children: alarms
                  .map((alarm) => ListTile(
                        title: Text(alarm.name),
                        onTap: () {
                          context.read<DatabaseProvider>().insertDeviceAlarm(
                              DeviceAlarmsTableCompanion.insert(
                                  deviceId: deviceId,
                                  alarmId: alarm.id,
                                  slot: slot));
                          // Implement adding alarm functionality
                          print('selected alarm');
                          print(alarm.toString());
                          Navigator.of(context).pop();
                        },
                      ))
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
