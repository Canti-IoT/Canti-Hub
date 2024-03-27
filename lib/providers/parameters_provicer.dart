import 'dart:convert';
import 'package:canti_hub/common/files.dart';
import 'package:canti_hub/common/parameters.dart';
import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/pages/main_page/main_page.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParametersProvider extends ChangeNotifier {
  List<Parameter> parameters = [];

  void loadParameters(BuildContext context) async {
    try {
      String contents =
          await DefaultAssetBundle.of(context).loadString(Files.parameters);

      var l = jsonDecode(contents);
      parameters = (l["parameters"] as List<dynamic>)
          .map((json) => Parameter.fromJson(json))
          .toList();

      notifyListeners();

      _insertParameters(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } catch (e) {
      print('Error loading parameters: $e');
    }
  }

  void _insertParameters(BuildContext context) async {
    var database = context.read<DatabaseProvider>();
    if (database.parameters.length != parameters.length) {
      for (var parameter in parameters) {
        database.insertParameter(ParametersTableCompanion(
            index: Value(parameter.index),
            name: Value(parameter.name),
            recurrence: Value(parameter.recurrence),
            normal: Value(parameter.normal),
            min: Value(parameter.min),
            max: Value(parameter.max)));
      }
    }
  }
}
