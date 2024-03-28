import 'package:canti_hub/database/custom_types.dart';
import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:canti_hub/pages/main_page/pages/add_device_page/widgets/device_type_widget.dart';
import 'package:canti_hub/pages/main_page/pages/add_device_page/widgets/mqtt_service_widget.dart';
import 'package:canti_hub/providers/device_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AddDevicePage extends StatelessWidget {
  const AddDevicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.arrow_back,
        title: localisation!.add_device,
        onLeftIconPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
            8.0, 8.0, 8.0, 8.0), // Added bottom padding for floating buttons
        children: [
          DeviceTypeWidget(),
          if (context.watch<DeviceProvider>().deviceType == DeviceType.virtual)
            MqttServiceWidget(),
        ],
      ),
    );
  }
}
