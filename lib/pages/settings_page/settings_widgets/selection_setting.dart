import 'package:flutter/material.dart';

class SelectionSetting extends StatefulWidget {
  final String label;
  final List<String> options;

  const SelectionSetting({required this.label, required this.options});

  @override
  _SelectionSettingState createState() => _SelectionSettingState();
}

class _SelectionSettingState extends State<SelectionSetting> {
  late String _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.options.first; // Set the default option
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.label),
          subtitle: Text(_selectedOption), // Display selected option
          onTap: () async {
            // Show a dialog or navigate to a new page for selection
            final selectedOption = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text(widget.label),
                  children: widget.options
                      .map((option) => SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context, option);
                            },
                            child: Text(option),
                          ))
                      .toList(),
                );
              },
            );

            if (selectedOption != null) {
              setState(() {
                _selectedOption = selectedOption;
              });
            }
          },
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Divider(
            height: 0, // Adjust the height as needed
          ),
        ),
      ],
    );
  }
}
