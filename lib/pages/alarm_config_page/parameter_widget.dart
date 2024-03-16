import 'package:canti_hub/pages/common/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class ParameterWidget extends StatefulWidget {
  @override
  _ParameterWidgetState createState() => _ParameterWidgetState();
}

class _ParameterWidgetState extends State<ParameterWidget> {
  int _configurationValue = 0;
  SfRangeValues _sliderValues = SfRangeValues(4.0, 7.0);

TextEditingController startValueController = TextEditingController();
TextEditingController endValueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color activeTrackColor;
    Color inactiveTrackColor;

    switch (_configurationValue) {
      case 0: // Disable
        activeTrackColor = Theme.of(context).colorScheme.inversePrimary;
        inactiveTrackColor = Theme.of(context).colorScheme.inversePrimary;
        break;
      case 1: // Inside
        activeTrackColor = Theme.of(context).colorScheme.primary;
        inactiveTrackColor = Theme.of(context).colorScheme.inversePrimary;
        break;
      case 2: // Outside
        activeTrackColor = Theme.of(context).colorScheme.inversePrimary;
        inactiveTrackColor = Theme.of(context).colorScheme.primary;
        break;
      default:
        activeTrackColor = Theme.of(context).colorScheme.inversePrimary;
        inactiveTrackColor = Theme.of(context).colorScheme.primary;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Parameter Name", // Replace with your parameter name
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Text(
            "Configuration:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Radio(
                value: 0,
                groupValue: _configurationValue,
                onChanged: (value) {
                  setState(() {
                    _configurationValue = value as int;
                  });
                },
              ),
              Text("Disable"),
              Radio(
                value: 1,
                groupValue: _configurationValue,
                onChanged: (value) {
                  setState(() {
                    _configurationValue = value as int;
                  });
                },
              ),
              Text("Inside"),
              Radio(
                value: 2,
                groupValue: _configurationValue,
                onChanged: (value) {
                  setState(() {
                    _configurationValue = value as int;
                  });
                },
              ),
              Text("Outside"),
            ],
          ),
          SizedBox(height: 16.0),
          Text(
            "Slider:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SfRangeSliderTheme(
                data: SfRangeSliderThemeData(
                  activeTrackHeight: 8,
                  inactiveTrackHeight: 8,
                  activeTrackColor: activeTrackColor,
                  inactiveTrackColor: inactiveTrackColor,
                  tooltipBackgroundColor: Theme.of(context).colorScheme.primary,
                  thumbColor: Theme.of(context).colorScheme.background,
                  thumbRadius: 15,
                  thumbStrokeWidth: 2,
                  thumbStrokeColor: Theme.of(context).colorScheme.primary,
                ),
                child: Expanded(
                  child: SfRangeSlider(
                    min: 2.0,
                    max: 10.0,
                    dragMode: SliderDragMode.both,
                    showLabels: true,
                    enableTooltip: true,
                    tooltipShape: SfPaddleTooltipShape(),
                    values: _sliderValues,
                    startThumbIcon: _configurationValue != 0
                        ? Icon(
                            _configurationValue == 1
                                ? Icons.arrow_forward_ios
                                : Icons.arrow_back_ios,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20.0,
                          )
                        : null,
                    endThumbIcon: _configurationValue != 0
                        ? Icon(
                            _configurationValue == 1
                                ? Icons.arrow_back_ios
                                : Icons.arrow_forward_ios,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20.0,
                          )
                        : null,
                    onChanged: (SfRangeValues values) {
                      setState(() {
                        _sliderValues = values;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Handle removal of this widget
                },
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _showValuePopup(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

 Future<void> _showValuePopup(BuildContext context) async {
  SfRangeValues newValues = _sliderValues;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Edit Values"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              controller: startValueController,
              decoration: InputDecoration(labelText: "Min Value"),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  double? newStartValue = double.tryParse(value);
                  if (newStartValue != null && newStartValue >= 2.0 && newStartValue <= 10.0) {
                    newValues = SfRangeValues(newStartValue, newValues.end);
                    // Update the slider position immediately
                    setState(() {
                      _sliderValues = newValues;
                    });
                    return null;
                  } else {
                    return "Invalid value";
                  }
                }
                return null;
              },
            ),
            SizedBox(height: 8.0),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: endValueController,
              decoration: InputDecoration(labelText: "Max Value"),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  double? newEndValue = double.tryParse(value);
                  if (newEndValue != null && newEndValue >= 2.0 && newEndValue <= 10.0) {
                    newValues = SfRangeValues(newValues.start, newEndValue);
                    // Update the slider position immediately
                    setState(() {
                      _sliderValues = newValues;
                    });
                    return null;
                  } else {
                    return "Invalid value";
                  }
                }
                return null;
              },
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
              setState(() {
                _sliderValues = newValues;
              });
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