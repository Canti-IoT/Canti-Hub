import 'package:canti_hub/database/custom_types.dart';
import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:flutter/material.dart';
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

  DeviceProvider() {
    _deviceType = DeviceType.bluetooth;
    _mqtt = MqttTableData(
        id: -1, serverUrl: 'uninitialized', username: 'uninitialized');
    parameters = [];
  }

  DeviceType get deviceType => _deviceType;
  MqttTableData get mqtt => _mqtt;

  set deviceType(DeviceType newDeviceType) {
    _deviceType = newDeviceType;
    notifyListeners();
  }

  set mqtt(MqttTableData newMqtt) {
    _mqtt = newMqtt;
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
    } else {
      // context.read<DatabaseProvider>().insertDevice(DevicesTableCompanion.insert(type: deviceType, ));
    }
    clean();
  }

  void clean() {
    _deviceType = DeviceType.mqtt;
    _mqtt = MqttTableData(
      id: -1,
      serverUrl: 'uninitialized',
      username: 'uninitialized',
    );

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
