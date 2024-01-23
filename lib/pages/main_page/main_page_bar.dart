import 'package:flutter/material.dart';

class MainPageBar extends StatelessWidget implements PreferredSizeWidget {
  const MainPageBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            // Handle settings icon press
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {
              // Handle alarm icon press
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
