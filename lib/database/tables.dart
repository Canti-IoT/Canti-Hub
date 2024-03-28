import 'package:canti_hub/database/custom_types.dart';
import 'package:drift/drift.dart';

class DevicesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get type => intEnum<DeviceType>()();
  TextColumn get softwareVersion => text()();
  TextColumn get hardwareVersion => text()();
}

class ParametersTable extends Table {
  IntColumn get index => integer()();
  TextColumn get name => text()();
  IntColumn get recurrence => integer()();
  IntColumn get normal => integer()();
  IntColumn get max => integer()();
  IntColumn get min => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {index};
}

class ColectedDataTable extends Table {
  IntColumn get parameterId => integer().references(ParametersTable, #index)();
  IntColumn get deviceId => integer().references(DevicesTable, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get value => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {parameterId, deviceId, createdAt};
}

class DeviceWifiTable extends Table {
  IntColumn get deviceId => integer().references(DevicesTable, #id)();
  IntColumn get wifiId => integer().references(WifiTable, #id)();

  @override
  Set<Column<Object>>? get primaryKey => {deviceId, wifiId};
}

class WifiTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ssid => text()();
  TextColumn get password => text()();
}

class MqttTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverUrl => text()();
  IntColumn get port =>
      integer().nullable().withDefault(const Constant(1883))();
  TextColumn get apiKey => text().nullable()();
  TextColumn get username => text()();
  TextColumn get password => text().nullable()();
}

class DeviceMqttTable extends Table {
  IntColumn get deviceId => integer().references(DevicesTable, #id)();
  IntColumn get mqttId => integer().references(MqttTable, #id)();

  @override
  Set<Column<Object>>? get primaryKey => {deviceId, mqttId};
}

class MqttParameterTable extends Table {
  IntColumn get parameterId => integer().references(ParametersTable, #index)();
  IntColumn get deviceId => integer().references(DevicesTable, #id)();
  IntColumn get mqttId => integer().references(MqttTable, #id)();
  TextColumn get topic => text()();

  @override
  Set<Column<Object>>? get primaryKey => {parameterId, deviceId, mqttId};
}

class AlarmsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get activated => boolean()();
}

class DeviceAlarmsTable extends Table {
  IntColumn get deviceId => integer().references(DevicesTable, #id)();
  IntColumn get alarmId => integer().references(AlarmsTable, #id)();

  @override
  Set<Column<Object>>? get primaryKey => {deviceId, alarmId};
}

class AlarmsParameterTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get alarmId => integer().references(AlarmsTable, #id)();
  IntColumn get parameterId => integer().references(ParametersTable, #index)();
  IntColumn get lowerValue => integer().nullable()();
  IntColumn get upperValue => integer().nullable()();
  IntColumn get triggerType => intEnum<TriggerType>()();
}
