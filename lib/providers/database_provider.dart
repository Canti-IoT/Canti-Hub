import 'dart:async';
import 'package:canti_hub/common/files.dart';
import 'package:canti_hub/database/database.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

class DatabaseProvider extends ChangeNotifier {
  late Database _database;
  int _selectedDeviceIndex = 0;
  late List<DevicesTableData> devices;
  late List<ParametersTableData> parameters;
  late List<ColectedDataTableData> collectedData;
  late List<DeviceWifiTableData> deviceWifi;
  late List<WifiTableData> wifi;
  late List<MqttTableData> mqtt;
  late List<MqttParameterTableData> mqttParameters;
  late List<AlarmsTableData> alarms;
  late List<DeviceAlarmsTableData> deviceAlarms;
  late List<AlarmsParameterTableData> alarmParameters;

  Database get database => _database;

  Future<void> initDatabase() async {
    _database = Database();
    await _database.customStatement('PRAGMA foreign_keys = ON');

    await getAllDevices();
    await getAllParameters();
    await getAllCollectedData();
    await getAllDeviceWifi();
    await getAllWifi();
    await getAllMqtt();
    await getAllMqttParameters();
    await getAllAlarms();
    await getAllDeviceAlarms();
    await getAllAlarmParameters(0);

    notifyListeners();
  }

  int get selectedDeviceIndex => _selectedDeviceIndex;
  set selectedDeviceIndex(int index) {
    _selectedDeviceIndex = index;
    notifyListeners();
  }
  // DevicesTable
  Future<int> insertDevice(DevicesTableCompanion device) async {
    int id = await _database.into(_database.devicesTable).insert(device);
    notifyListeners();
    await getAllDevices();
    return id;
  }

  Future<void> getAllDevices() async {
    devices = await _database.select(_database.devicesTable).get();
    notifyListeners();
  }

  Future<void> updateDevice(DevicesTableData device) async {
    await _database.update(_database.devicesTable).replace(device);
    notifyListeners();
  }

  // ParametersTable
  Future<void> upsertParameter(ParametersTableCompanion parameter) async {
    await _database
        .into(_database.parametersTable)
        .insertOnConflictUpdate(parameter);
    notifyListeners();
    await getAllParameters();
  }

  Future<void> insertParameter(ParametersTableCompanion parameter) async {
    await _database
        .into(_database.parametersTable)
        .insert(parameter, mode: InsertMode.insertOrIgnore);
    notifyListeners();
    await getAllParameters();
  }

  Future<void> getAllParameters() async {
    parameters = await _database.select(_database.parametersTable).get();
    notifyListeners();
  }

  Future<ParametersTableData?> getParameterById(int id) async {
    var parameter = await (_database.select(_database.parametersTable)
          ..where((tbl) => tbl.index.equals(id)))
        .getSingle();
    return parameter;
  }

  Future<void> updateParameter(ParametersTableData parameter) async {
    await _database.update(_database.parametersTable).replace(parameter);
    notifyListeners();
    await getAllParameters();
  }

  // ColectedDataTable
  Future<void> insertCollectedData(ColectedDataTableData data) async {
    await _database.into(_database.colectedDataTable).insert(data);
    notifyListeners();
  }

  Future<void> getAllCollectedData() async {
    collectedData = await _database.select(_database.colectedDataTable).get();
    notifyListeners();
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

  Future<void> getAllDeviceWifi() async {
    deviceWifi = await _database.select(_database.deviceWifiTable).get();
    notifyListeners();
  }

  Future<void> updateDeviceWifi(DeviceWifiTableData deviceWifi) async {
    await _database.update(_database.deviceWifiTable).replace(deviceWifi);
    notifyListeners();
  }

  // WifiTable
  Future<void> insertWifi(WifiTableCompanion wifi) async {
    await _database.into(_database.wifiTable).insert(wifi);
    notifyListeners();
    await getAllWifi();
  }

  Future<void> getAllWifi() async {
    wifi = await _database.select(_database.wifiTable).get();
    notifyListeners();
  }

  Future<void> updateWifi(WifiTableData wifi) async {
    await _database.update(_database.wifiTable).replace(wifi);
    notifyListeners();
    await getAllWifi();
  }

  Future<void> deleteWifi(WifiTableData wifi) async {
    await _database.delete(_database.wifiTable).delete(wifi);
    notifyListeners();
    await getAllWifi();
  }

  // MqttTable
  Future<void> insertMqtt(MqttTableCompanion mqtt) async {
    await _database.into(_database.mqttTable).insert(mqtt);
    notifyListeners();
    await getAllMqtt();
  }

  Future<void> getAllMqtt() async {
    mqtt = await _database.select(_database.mqttTable).get();
    notifyListeners();
  }

  Future<void> updateMqtt(MqttTableData mqtt) async {
    await _database.update(_database.mqttTable).replace(mqtt);
    notifyListeners();
    await getAllMqtt();
  }

  Future<void> deleteMqtt(MqttTableData mqtt) async {
    await _database.delete(_database.mqttTable).delete(mqtt);
    notifyListeners();
    await getAllMqtt();
  }

  // MqttParameterTable
  Future<void> insertMqttParameter(MqttParameterTableData parameter) async {
    await _database.into(_database.mqttParameterTable).insert(parameter);
    notifyListeners();
  }

  Future<void> getAllMqttParameters() async {
    mqttParameters = await _database.select(_database.mqttParameterTable).get();
    notifyListeners();
  }

  Future<void> updateMqttParameter(MqttParameterTableData parameter) async {
    await _database.update(_database.mqttParameterTable).replace(parameter);
    notifyListeners();
  }

  // AlarmsTable
  Future<AlarmsTableData?> insertAlarm(AlarmsTableCompanion alarm) async {
    final id = await _database.into(_database.alarmsTable).insert(alarm);
    notifyListeners();
    getAllAlarms();

    final insertedAlarm = await (_database.select(_database.alarmsTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    return insertedAlarm;
  }

  Future<void> getAllAlarms() async {
    alarms = await _database.select(_database.alarmsTable).get();
    notifyListeners();
  }

  Future<void> updateAlarm(AlarmsTableData alarm) async {
    await _database.update(_database.alarmsTable).replace(alarm);
    notifyListeners();
    await getAllAlarms();
  }

  Future<void> deleteAlarm(AlarmsTableData alarm) async {
    await _database.delete(_database.alarmsTable).delete(alarm);
    notifyListeners();
    await getAllAlarms();
  }

  // DeviceAlarmsTable
  Future<void> insertDeviceAlarm(DeviceAlarmsTableData deviceAlarm) async {
    await _database.into(_database.deviceAlarmsTable).insert(deviceAlarm);
    notifyListeners();
  }

  Future<void> getAllDeviceAlarms() async {
    deviceAlarms = await _database.select(_database.deviceAlarmsTable).get();
    notifyListeners();
  }

  Future<void> updateDeviceAlarm(DeviceAlarmsTableData deviceAlarm) async {
    await _database.update(_database.deviceAlarmsTable).replace(deviceAlarm);
    notifyListeners();
  }

  // AlarmsParameterTable
  Future<void> insertAlarmParameter(
      AlarmsParameterTableCompanion parameter) async {
    await _database.into(_database.alarmsParameterTable).insert(parameter);
    notifyListeners();
    await getAllAlarmParameters(parameter.alarmId.value);
  }

  Future<void> getAllAlarmParameters(int alarmId) async {
    // Await the result of the query
    alarmParameters = await (_database.select(_database.alarmsParameterTable)
          ..where((tbl) => tbl.alarmId.equals(alarmId)))
        .get();
    notifyListeners();
  }

  Future<void> updateAlarmParameter(AlarmsParameterTableData parameter) async {
    await _database.update(_database.alarmsParameterTable).replace(parameter);
    notifyListeners();
    await getAllAlarmParameters(parameter.alarmId);
  }

  Future<void> deleteAlarmParameter(AlarmsParameterTableData parameter) async {
    await _database.delete(_database.alarmsParameterTable).delete(parameter);
    notifyListeners();
    await getAllAlarmParameters(parameter.alarmId);
  }
}
