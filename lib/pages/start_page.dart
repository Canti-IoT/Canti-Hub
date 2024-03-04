import 'package:canti_hub/pages/main_page/main_page.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

class StartPage extends StatelessWidget {
  const StartPage({Key? key});

  @override
  Widget build(BuildContext context) {
    // Wait for 2 seconds (adjust the duration as needed)
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    });

    return Scaffold(
      body: Container(
        child: Center(
          child: Transform.rotate(
            angle: -math.pi / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Canti ',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 40),
                ),
                Text(
                  'Hub',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
