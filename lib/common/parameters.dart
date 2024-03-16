import 'dart:convert';
import 'dart:io';

class Parameter {
  final String name;
  final int index;
  final int normal;
  final int max;
  final int min;

  Parameter(
      {required this.name,
      required this.index,
      required this.normal,
      required this.max,
      required this.min});

  factory Parameter.fromJson(Map<String, dynamic> json) {
    return Parameter(
      name: json['name'],
      index: json['index'],
      normal: json['normal'],
      max: json['max'],
      min: json['min'],
    );
  }
}
