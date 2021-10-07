import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinkitScreen extends StatelessWidget {
  const SpinkitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinKitRipple(
          color: Colors.indigo,
          size: 100,
        ),
      ),
    );
  }
}
