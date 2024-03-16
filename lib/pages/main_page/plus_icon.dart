import 'package:canti_hub/pages/detail_page/detail_page.dart';
import 'package:flutter/material.dart';

class PlusIcon extends StatelessWidget {
  const PlusIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => DetailPage()),
          // );
        },
        child: Container(
          width: 76,
          child: Stack(
            children: [
              // Image Container (below)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Color.fromRGBO(128, 128, 128, 0.2),
                    BlendMode.srcOver,
                  ),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.add_circle,
                      size: 24.0,
                    ),
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
