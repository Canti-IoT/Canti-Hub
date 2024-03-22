import 'package:canti_hub/pages/settings_page/pages/wifi_page/detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:canti_hub/pages/common/custom_app_bar.dart';

class WifiSettingsPage extends StatelessWidget {
  const WifiSettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.arrow_back,
        title: localisation!
            .settings_wifi, // Use the provided pageTitle for the app bar title
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
          ),
          DetailWidget(
            title: 'Title 3',
            onEditPressed: () {},
            onRemovePressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showWifiPopup(context);
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
}
