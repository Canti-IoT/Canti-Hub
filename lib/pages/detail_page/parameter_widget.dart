import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ParameterWidget extends StatelessWidget {
  final String parameterName;
  final double value;
  final String unit;
  final double minValue;
  final double maxValue;
  final double desiredValue;

  const ParameterWidget({
    Key? key,
    required this.parameterName,
    required this.value,
    required this.unit,
    required this.minValue,
    required this.maxValue,
    required this.desiredValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayValue = formatValue(value);

    return Container(
      margin: EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: minValue,
                          maximum: maxValue,
                          showLabels: false,
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: value,
                              width: 0.15,
                              color: colorizeGauge(),
                              sizeUnit: GaugeSizeUnit.factor,
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Text(
                                '$displayValue $unit',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              angle: 90,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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

  Color colorizeGauge() {
    Color color;
    double distanceToDesired = (value - desiredValue).abs();

    if (distanceToDesired < 0.05 * (maxValue - minValue)) {
      color = Colors.green;
    } else if (distanceToDesired < 0.2 * (maxValue - minValue)) {
      color = Colors.yellow;
    } else {
      color = Colors.red;
    }

    return color;
  }
}
