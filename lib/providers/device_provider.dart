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
    _deviceType = DeviceType.physical;
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
        topic: '',
      ));
    }

    parameters = tmpParameters;
    notifyListeners();
  }
}
