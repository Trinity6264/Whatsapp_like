import 'package:flutter/material.dart';
import 'package:project1/ui/signIn.dart';
import 'package:project1/ui/signUp.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isToggle = false;
  void toggleView() {
    setState(() {
      isToggle = !isToggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isToggle
        ? SignIn(toggleView: toggleView)
        : SignUp(toggleView: toggleView);
  }
}
