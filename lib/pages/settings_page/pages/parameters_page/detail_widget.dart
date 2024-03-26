import 'package:canti_hub/common/parameters.dart';
import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:canti_hub/providers/parameters_provicer.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailWidget extends StatelessWidget {
  final ParametersTableData parameter;

  const DetailWidget({
    required this.parameter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                parameter.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                iconSize: 36,
                onPressed: () => _showPopup(context),
              ),
            ],
          ),
        ),
        Divider(height: 0),
      ],
    );
  }

  Future<void> _showPopup(BuildContext context) async {
    String recurrence = parameter.recurrence.toString();
    String normal = parameter.normal.toString();
    String min = parameter.min.toString();
    String max = parameter.max.toString();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Modify Parameter"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: recurrence,
                  onChanged: (value) {
                    recurrence = value;
                  },
                  decoration: InputDecoration(labelText: "Recurrence"),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: normal,
                  onChanged: (value) {
                    normal = value;
                  },
                  decoration: InputDecoration(labelText: "Normal"),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: max,
                  onChanged: (value) {
                    max = value;
                  },
                  decoration: InputDecoration(labelText: "Max"),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: min,
                  onChanged: (value) {
                    min = value;
                  },
                  decoration: InputDecoration(labelText: "Min"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                var defaultParameter = context
                    .read<ParametersProvider>()
                    .parameters
                    .firstWhere((d) => d.index == parameter.index,
                        orElse: () =>
                            context.read<ParametersProvider>().parameters[0]);
                context
                    .read<DatabaseProvider>()
                    .updateParameter(parameter.copyWith(
                      recurrence: defaultParameter.recurrence,
                      normal: defaultParameter.normal,
                      min: defaultParameter.min,
                      max: defaultParameter.max,
                    ));

                Navigator.of(context).pop();
              },
              child: Text('Default'),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<DatabaseProvider>()
                    .updateParameter(parameter.copyWith(
                      recurrence: int.parse(recurrence),
                      normal: int.parse(normal),
                      min: int.parse(min),
                      max: int.parse(max),
                    ));
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
