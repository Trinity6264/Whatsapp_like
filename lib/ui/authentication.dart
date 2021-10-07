import 'package:flutter/material.dart';
import 'package:project1/models/current_user_model.dart';
import 'package:project1/ui/home_screen.dart';
import 'package:project1/ui/wrapper.dart';
import 'package:provider/provider.dart';

class Authentication extends StatelessWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userCurrent = Provider.of<CurrentUserModel?>(context);
    return _userCurrent != null ? Home() : Wrapper();
  }
}
