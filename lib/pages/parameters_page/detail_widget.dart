import 'package:canti_hub/common/parameters.dart';
import 'package:flutter/material.dart';

class DetailWidget extends StatelessWidget {
  final Parameter parameter;

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
                Navigator.of(context).pop();
              },
              child: Text('Default'),
            ),
            TextButton(
              onPressed: () {
                // Perform actions with the updated parameter here
                print("Updated Parameter:");
                print("Recurrence: $recurrence");
                print("Normal: $normal");
                print("Max: $max");
                print("Min: $min");

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
