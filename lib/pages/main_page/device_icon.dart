import 'package:canti_hub/common/files.dart';
import 'package:canti_hub/pages/detail_page/detail_page.dart';
import 'package:flutter/material.dart';

class DeviceIcon extends StatelessWidget {
  const DeviceIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).backgroundColor;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailPage()),
        );
      },
      child: Container(
        width: 76,
        child: Stack(
          children: [
            // Image Container (below)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  Files.bme680,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 12,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                  border: Border.all(color: backgroundColor, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
