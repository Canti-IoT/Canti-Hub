import 'package:canti_hub/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParameterWidget extends StatelessWidget {
  final String parameterName;
  final double value;
  final String unit;
  final double desiredValue;

  const ParameterWidget({
    Key? key,
    required this.parameterName,
    required this.value,
    required this.unit,
    required this.desiredValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayMode = context.watch<SettingsProvider>().displayMode;

    return displayMode == ParametersDisplayMode.list
        ? _buildListLayout(context)
        : _buildGridLayout(context);
  }

  Widget _buildListLayout(BuildContext context) {
  String displayValue = formatValue(value);

  return Container(
    margin: EdgeInsets.all(5.0),
    child: Container(
      padding: EdgeInsets.all(16.0), // Padding of 8
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              parameterName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 8), // Adjust spacing as needed
          Text(
            '$displayValue $unit',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    ),
  );
}


  Widget _buildGridLayout(BuildContext context) {
    String displayValue = formatValue(value);

    return Container(
      margin: EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$displayValue ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 8), // Adjust spacing as needed
            Text(
              parameterName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatValue(double value) {
    if (value % 1 == 0 || value % 1 == 0.1 || value % 1 == 0.9) {
      return value.round().toString();
    } else {
      return value.toStringAsFixed(1);
    }
  }
}