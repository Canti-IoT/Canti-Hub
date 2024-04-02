import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:canti_hub/pages/detail_page/parameter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localisation = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.arrow_back,
        title: '1/1',
        onLeftIconPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        children: [
          // Add ParameterWidget instances for different parameters
          ParameterWidget(
            parameterName: 'Temperature',
            value: 26.0, // Replace with actual value
            desiredValue: 21.0,
            unit: '°C',
          ),
          ParameterWidget(
            parameterName: 'Humidity',
            value: 50.0, // Replace with actual value
            desiredValue: 50.0,
            unit: '%',
          ),
          ParameterWidget(
            parameterName: 'Air Quality(VOCs)',
            value: 0.6, // Replace with actual value
            desiredValue: 1.0,
            unit: '%',
          ),
          ParameterWidget(
            parameterName: 'Pressure',
            value: 1000.0, // Replace with actual value
            desiredValue: 1010.0,
            unit: 'Pa',
          ),
          ParameterWidget(
            parameterName: 'Noise Level',
            value: 30.0, // Replace with actual value
            desiredValue: 1.0,
            unit: 'dB',
          ),
          ParameterWidget(
            parameterName: 'Light Level',
            value: 500.0, // Replace with actual value
            desiredValue: 50.0,
            unit: 'lux',
          ),
        ],
      ),
    );
  }
}
