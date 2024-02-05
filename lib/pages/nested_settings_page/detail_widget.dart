import 'package:flutter/material.dart';

class DetailWidget extends StatelessWidget {
  final String title;
  final bool showToggle;
  final bool toggleValue;
  final VoidCallback? onToggleChanged;
  final VoidCallback? onRemovePressed;

  const DetailWidget({
    required this.title,
    this.showToggle = false,
    this.toggleValue = false,
    this.onToggleChanged,
    this.onRemovePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showToggle)
                Switch(
                  value: toggleValue,
                  onChanged: (newValue) {
                    onToggleChanged?.call();
                  },
                ),
              if (!showToggle)
                IconButton(
                  icon: Icon(Icons.delete),
                  iconSize: 36,
                  onPressed: onRemovePressed,
                ),
            ],
          ),
        ),
        Divider(height: 0),
      ],
    );
  }
}
