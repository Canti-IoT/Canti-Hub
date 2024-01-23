import 'package:canti_hub/pages/main_page/main_page_bar.dart';
import 'package:canti_hub/pages/main_page/devices_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horizontal scrollable list of avatars
          Container(
            margin: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              localisation!.devices,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          DevicesList(),

          // Placeholder for the heatmap or any other content
          Container(
            margin: EdgeInsets.all(16),
            child: Text(
              'Placeholder for Heatmap or other content',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
