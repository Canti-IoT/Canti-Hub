import 'package:canti_hub/providers/database_provider.dart';
import 'package:canti_hub/providers/parameters_provicer.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

import 'package:provider/provider.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      context.read<DatabaseProvider>().initDatabase();
      context.read<ParametersProvider>().loadParameters(context);
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
