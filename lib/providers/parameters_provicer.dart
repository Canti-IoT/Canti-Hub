import 'dart:convert';
import 'package:canti_hub/common/files.dart';
import 'package:canti_hub/common/parameters.dart';
import 'package:canti_hub/pages/main_page/main_page.dart';
import 'package:flutter/material.dart';

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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } catch (e) {
      print('Error loading parameters: $e');
    }
  }
}
