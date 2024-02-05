import 'package:canti_hub/pages/alarm_config_page/parameter_widget.dart';
import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlarmConfigPage extends StatelessWidget {
  const AlarmConfigPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.arrow_back,
        title: localisation!.alarms_config,
        onLeftIconPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Editable Alarm Name
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
            ),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Alarm Name",
              ),
              controller:
                  TextEditingController(text: "Alarm 1"), // Default value
            ),
          ),


          // Parameter Configuration Widget
          ParameterWidget(),

          // Your other widgets go here

          // Add more ParameterWidgets as needed
          ParameterWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Handle the button press, e.g., open a dialog or navigate to another screen
        },
        icon: Icon(Icons.add),
        label: Text(
          "Add Parameter",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
