import 'package:canti_hub/pages/nested_settings_page/detail_widget.dart';
import 'package:canti_hub/pages/settings_page/pages/parameters_page/parameters_page.dart';
import 'package:canti_hub/pages/settings_page/pages/wifi_page/wifi_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:canti_hub/pages/common/settings_type.dart';
import 'package:canti_hub/pages/alarm_config_page/alarm_config_page.dart';

class NestedSettingsPage extends StatelessWidget {
  final String pageTitle;
  final SettingsType pageType; // Add this variable to identify page type

  const NestedSettingsPage({
    Key? key,
    required this.pageTitle,
    required this.pageType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    switch (pageType) {
      case SettingsType.recurrence:
        return ParametersPage();
        break;
      case SettingsType.wifi:
        return WifiSettingsPage();
        break;
      case SettingsType.mqtt:
        // _showMqttPopup(context);
        break;
      case SettingsType.alarms:
        break;
      default:
        break;
    }
    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.arrow_back,
        title: pageTitle, // Use the provided pageTitle for the app bar title
        onLeftIconPressed: () {
          Navigator.of(context).pop();
          // Navigator.popUntil(context, (route) => route.isFirst);
          print('here');
        },
      ),
      body: ListView(
        children: [
          DetailWidget(
            title: 'Title 1',
          ),
          DetailWidget(
            title: 'Title 2',
            showToggle: true,
            toggleValue: true,
            onToggleChanged: () {
              // Handle toggle change
            },
          ),
          DetailWidget(
            title: 'Title 3',
            onRemovePressed: () {
              // Handle remove action
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          switch (pageType) {
            case SettingsType.recurrence:
              break;
            case SettingsType.wifi:
              _showWifiPopup(context);
              break;
            case SettingsType.mqtt:
              _showMqttPopup(context);
              break;
            case SettingsType.alarms:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlarmConfigPage()),
              );
              break;
            default:
              break;
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showWifiPopup(BuildContext context) async {
    String ssid = "Initial SSID";
    String password = "Initial Password";

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("WiFi Connection"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: ssid,
                onChanged: (value) {
                  // Update ssid when input changes
                  ssid = value;
                },
                decoration: InputDecoration(labelText: "SSID"),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: password,
                onChanged: (value) {
                  // Update password when input changes
                  password = value;
                },
                decoration: InputDecoration(labelText: "Password"),
              ),
            ],
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
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMqttPopup(BuildContext context) async {
    String serverUrl = "Initial SSID";
    String port = "Initial SSID";
    String key = "api key";
    String username = "username";
    String password = "";

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("MQTT Connection"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: serverUrl,
                  onChanged: (value) {
                    // Update serverUrl when input changes
                    serverUrl = value;
                  },
                  decoration: InputDecoration(labelText: "Server URL"),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: port,
                  onChanged: (value) {
                    // Update port when input changes
                    port = value;
                  },
                  decoration: InputDecoration(labelText: "Port"),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: key,
                  onChanged: (value) {
                    // Update key when input changes
                    key = value;
                  },
                  decoration: InputDecoration(labelText: "API Key"),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: username,
                  onChanged: (value) {
                    // Update username when input changes
                    username = value;
                  },
                  decoration: InputDecoration(labelText: "Username"),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  initialValue: password,
                  onChanged: (value) {
                    // Update password when input changes
                    password = value;
                  },
                  decoration: InputDecoration(labelText: "Password"),
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
                // Perform actions with the MQTT connection settings here
                // For example: connect to MQTT broker
                print("Connecting to MQTT Broker...");
                print("Server URL: $serverUrl");
                print("Port: $port");
                print("API Key: $key");
                print("Username: $username");
                print("Password: $password");

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
