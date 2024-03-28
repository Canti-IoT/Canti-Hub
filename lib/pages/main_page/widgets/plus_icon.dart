import 'package:canti_hub/database/custom_types.dart';
import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlusIcon extends StatelessWidget {
  const PlusIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () async {},
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
                  child: Icon(
                    Icons.add_circle,
                    size: 36.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
