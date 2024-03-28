import 'package:canti_hub/pages/main_page/widgets/device_icon.dart';
import 'package:canti_hub/pages/main_page/widgets/plus_icon.dart';
import 'package:flutter/material.dart';

class DevicesList extends StatelessWidget {
  const DevicesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Adjust the number of avatars as needed
        itemBuilder: (context, index) {
          // Example CircleAvatar with a dot for online/offline indicator
          if (index < 4) {
            return DeviceIcon();
          } else {
            return PlusIcon();
          }
        },
      ),
    );
  }
}
