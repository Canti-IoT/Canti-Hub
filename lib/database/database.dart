import 'dart:io';
import 'package:canti_hub/database/tables.dart';
import 'package:canti_hub/database/custom_types.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'database.sqlite'));

    return NativeDatabase(file, logStatements: true);
  });
}

@DriftDatabase(tables: [
  DevicesTable,
  ParametersTable,
  ColectedDataTable,
  DeviceWifiTable,
  WifiTable,
  MqttTable,
  MqttParameterTable,
  AlarmsTable,
  DeviceAlarmsTable,
  AlarmsParameterTable
])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}