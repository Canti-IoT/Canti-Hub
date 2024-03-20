import 'package:canti_hub/database/database.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

class DatabaseProvider extends ChangeNotifier {
  late Database _database;

  Database get database => _database;

  Future<void> initDatabase() async {
    _database = Database();
    await _database.customStatement('PRAGMA foreign_keys = ON');
    notifyListeners();
  }

  // DevicesTable
  Future<void> insertDevice(DevicesTableCompanion device) async {
    _database.into(_database.devicesTable).insert(device);
    notifyListeners();
  }

  Future<List<DevicesTableData>> getAllDevices() async {
    return await _database.select(_database.devicesTable).get();
  }

  Future<void> updateDevice(DevicesTableData device) async {
    await _database.update(_database.devicesTable).replace(device);
    notifyListeners();
  }

  // ParametersTable
  Future<void> insertParameter(ParametersTableData parameter) async {
    await _database.into(_database.parametersTable).insert(parameter);
    notifyListeners();
  }

  Future<List<ParametersTableData>> getAllParameters() async {
    return await _database.select(_database.parametersTable).get();
  }

  Future<void> updateParameter(ParametersTableData parameter) async {
    await _database.update(_database.parametersTable).replace(parameter);
    notifyListeners();
  }

  // ColectedDataTable
  Future<void> insertCollectedData(ColectedDataTableData data) async {
    await _database.into(_database.colectedDataTable).insert(data);
    notifyListeners();
  }

  Future<List<ColectedDataTableData>> getAllCollectedData() async {
    return await _database.select(_database.colectedDataTable).get();
  }

  Future<void> updateCollectedData(ColectedDataTableData data) async {
    await _database.update(_database.colectedDataTable).replace(data);
    notifyListeners();
  }

  // DeviceWifiTable
  Future<void> insertDeviceWifi(DeviceWifiTableData deviceWifi) async {
    await _database.into(_database.deviceWifiTable).insert(deviceWifi);
    notifyListeners();
  }

  Future<List<DeviceWifiTableData>> getAllDeviceWifi() async {
    return await _database.select(_database.deviceWifiTable).get();
  }

  Future<void> updateDeviceWifi(DeviceWifiTableData deviceWifi) async {
    await _database.update(_database.deviceWifiTable).replace(deviceWifi);
    notifyListeners();
  }

  // WifiTable
  Future<void> insertWifi(WifiTableData wifi) async {
    await _database.into(_database.wifiTable).insert(wifi);
    notifyListeners();
  }

  Future<List<WifiTableData>> getAllWifi() async {
    return await _database.select(_database.wifiTable).get();
  }

  Future<void> updateWifi(WifiTableData wifi) async {
    await _database.update(_database.wifiTable).replace(wifi);
    notifyListeners();
  }

  // MqttTable
  Future<void> insertMqtt(MqttTableData mqtt) async {
    await _database.into(_database.mqttTable).insert(mqtt);
    notifyListeners();
  }

  Future<List<MqttTableData>> getAllMqtt() async {
    return await _database.select(_database.mqttTable).get();
  }

  Future<void> updateMqtt(MqttTableData mqtt) async {
    await _database.update(_database.mqttTable).replace(mqtt);
    notifyListeners();
  }

  // MqttParameterTable
  Future<void> insertMqttParameter(MqttParameterTableData parameter) async {
    await _database.into(_database.mqttParameterTable).insert(parameter);
    notifyListeners();
  }

  Future<List<MqttParameterTableData>> getAllMqttParameters() async {
    return await _database.select(_database.mqttParameterTable).get();
  }

  Future<void> updateMqttParameter(MqttParameterTableData parameter) async {
    await _database.update(_database.mqttParameterTable).replace(parameter);
    notifyListeners();
  }

  // AlarmsTable
  Future<void> insertAlarm(AlarmsTableData alarm) async {
    await _database.into(_database.alarmsTable).insert(alarm);
    notifyListeners();
  }

  Future<List<AlarmsTableData>> getAllAlarms() async {
    return await _database.select(_database.alarmsTable).get();
  }

  Future<void> updateAlarm(AlarmsTableData alarm) async {
    await _database.update(_database.alarmsTable).replace(alarm);
    notifyListeners();
  }

  // DeviceAlarmsTable
  Future<void> insertDeviceAlarm(DeviceAlarmsTableData deviceAlarm) async {
    await _database.into(_database.deviceAlarmsTable).insert(deviceAlarm);
    notifyListeners();
  }

  Future<List<DeviceAlarmsTableData>> getAllDeviceAlarms() async {
    return await _database.select(_database.deviceAlarmsTable).get();
  }

  Future<void> updateDeviceAlarm(DeviceAlarmsTableData deviceAlarm) async {
    await _database.update(_database.deviceAlarmsTable).replace(deviceAlarm);
    notifyListeners();
  }

  // AlarmsParameterTable
  Future<void> insertAlarmParameter(AlarmsParameterTableData parameter) async {
    await _database.into(_database.alarmsParameterTable).insert(parameter);
    notifyListeners();
  }

  Future<List<AlarmsParameterTableData>> getAllAlarmParameters() async {
    return await _database.select(_database.alarmsParameterTable).get();
  }

  Future<void> updateAlarmParameter(AlarmsParameterTableData parameter) async {
    await _database.update(_database.alarmsParameterTable).replace(parameter);
    notifyListeners();
  }
}
