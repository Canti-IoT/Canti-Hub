import 'package:flutter/material.dart';
import 'dart:math' as math;

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
          child: Transform.rotate(
              angle: -math.pi / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      style: TextStyle(fontFamily: "Robot", fontSize: 40),
                      "Canti "),
                  Text(
                      style: TextStyle(
                          fontFamily: "Robot",
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                      "Hub"),
                ],
              ))),
    ));
  }
}
