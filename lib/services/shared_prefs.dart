import 'package:flutter/material.dart';
import 'package:project1/services/custom_firebase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs with ChangeNotifier {
  // making the class singleton
  SharedPrefs._();
  static final instance = SharedPrefs._();

  //Function for Saving settings data
  Future<bool> saveData(BuildContext context) async {
    final _pro = Provider.of<CustomFirebase>(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool('isRounded', _pro.isRounded!);
  }

  //Function for retrieving settings data
  Future<void> retrieveData(BuildContext context) async {
    final _pro = Provider.of<CustomFirebase>(context);
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    _pro.isRounded = prefs.getBool('isRounded') ?? false;
    notifyListeners();
  }
}
