import 'package:canti_hub/database/custom_types.dart';
import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

class MqttParameter {
  final int id;
  final int index;
  final String name;
  bool checkbox;
  String topic;

  MqttParameter({
    required this.id,
    required this.index,
    required this.name,
    required this.checkbox,
    required this.topic,
  });
}

class DeviceProvider with ChangeNotifier {
  late DeviceType _deviceType;
  late MqttTableData _mqtt;
  late List<MqttParameter> parameters;
  late String _name = '';
  late BluetoothDevice _device =
      BluetoothDevice(remoteId: DeviceIdentifier('0'));

  DeviceProvider() {
    _deviceType = DeviceType.bluetooth;
    _mqtt = MqttTableData(
        id: -1, serverUrl: 'uninitialized', username: 'uninitialized');
    parameters = [];
  }

  DeviceType get deviceType => _deviceType;
  MqttTableData get mqtt => _mqtt;
  String get name => _name;
  BluetoothDevice get device => _device;

  set device(BluetoothDevice device) {
    _device = device;
    notifyListeners();
  }

  set deviceType(DeviceType newDeviceType) {
    _deviceType = newDeviceType;
    notifyListeners();
  }

  set mqtt(MqttTableData newMqtt) {
    _mqtt = newMqtt;
    notifyListeners();
  }

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  void loadParameters(BuildContext context) {
    List<MqttParameter> tmpParameters = [];

    for (var index = 0;
        index < context.read<DatabaseProvider>().parameters.length;
        index++) {
      var parameter = context.read<DatabaseProvider>().parameters[index];

      // Now you can access parameter.index, parameter.name, etc.
      tmpParameters.add(MqttParameter(
        id: parameter.index,
        index: index,
        name: parameter.name,
        checkbox: false,
        topic: '\${USERNAME}/feeds/\${PARAMETER}',
      ));
    }

    parameters = tmpParameters;
  }

  void save(BuildContext context) async {
    if (deviceType == DeviceType.mqtt) {
      int mqttId = await context.read<DatabaseProvider>().insertDevice(
          DevicesTableCompanion.insert(
              type: deviceType,
              remoteId: '',
              name: 'mqtt',
              displayNmae: 'mqtt',
              softwareVersion: 'mqtt',
              hardwareVersion: 'mqtt'));

      Map<String, String> replacements = {
        'USERNAME': mqtt.username,
        'PARAMETER': '',
      };

      for (var parameter in parameters) {
        replacements['PARAMETER'] = parameter.name;
        parameter.topic = _replacePlaceholders(parameter.topic, replacements);
        print(parameter.topic);
      }
    } else if (deviceType == DeviceType.bluetooth) {
      var devicesList = context.read<DatabaseProvider>().devices;
      print("#########");
      print(devicesList.toString());
      DevicesTableData? existingDevice = null;
      try {
        existingDevice = devicesList
            .firstWhere((device) => device.remoteId == _device.remoteId.str);
      } catch (e) {}
      if (existingDevice == null) {
        await context.read<DatabaseProvider>().insertDevice(
            DevicesTableCompanion.insert(
                type: deviceType,
                remoteId: _device.remoteId.str,
                name: device.platformName,
                displayNmae: _name == '' ? device.platformName : _name,
                softwareVersion: 'bluetooth',
                hardwareVersion: 'bluetooth'));
      }
      else{
      }
    }
    clean();
  }

  void clean() {
    _deviceType = DeviceType.bluetooth;
    _mqtt = MqttTableData(
      id: -1,
      serverUrl: 'uninitialized',
      username: 'uninitialized',
    );
    name = '';
    device = BluetoothDevice(remoteId: DeviceIdentifier('0'));

    // Reset boolean value and topic for each parameter
    parameters.forEach((parameter) {
      parameter.checkbox = false;
      parameter.topic = '\${USERNAME}/feeds/\${PARAMETER}';
    });
    notifyListeners();
  }

  String _replacePlaceholders(String input, Map<String, String> replacements) {
    String result = input;
    replacements.forEach((key, value) {
      if (result.contains('\${$key}')) {
        result = result.replaceAll('\${$key}', value);
      } else {
        result = result.replaceAll('\${$key}', '<!-- ${key} is missing -->');
      }
    });
    return result;
  }
}
