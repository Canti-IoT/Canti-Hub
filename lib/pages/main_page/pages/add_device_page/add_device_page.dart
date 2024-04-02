import 'package:canti_hub/database/custom_types.dart';
import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:canti_hub/pages/main_page/pages/add_device_page/widgets/device_type_widget.dart';
import 'package:canti_hub/pages/main_page/pages/add_device_page/widgets/mqtt_parameter_widget.dart';
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
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 80.0),
        children: [
          DeviceTypeWidget(),
          if (context.watch<DeviceProvider>().deviceType == DeviceType.virtual)
            MqttServiceWidget(),
          // if (context.watch<DeviceProvider>().deviceType == DeviceType.virtual)
          ...context
              .watch<DeviceProvider>()
              .parameters
              .where((parameter) =>
                  context.watch<DeviceProvider>().deviceType ==
                  DeviceType.virtual)
              .map((parameter) => MqttParameterWidget(
                    parameter: parameter,
                    onCheckboxChanged: (value) {
                      // Update checkbox value in your provider or wherever you store state
                      context
                          .read<DeviceProvider>()
                          .parameters[parameter.index]
                          .checkbox = value;
                    },
                    onTopicChanged: (value) {
                      // Update topic value in your provider or wherever you store state
                      context
                          .read<DeviceProvider>()
                          .parameters[parameter.index]
                          .topic = value;
                    },
                  ))
              .toList(),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: FloatingActionButton.extended(
              heroTag: "cancel",
              onPressed: () {
                // Do nothing for delete button tap
              },
              icon: Icon(Icons.cancel),
              label: Text(
                localisation!.cancel,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          FloatingActionButton.extended(
            heroTag: "add parameter",
            onPressed: () {
              context.read<DeviceProvider>().save(context);
            },
            icon: Icon(Icons.add),
            label: Text(
              localisation!.add,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
