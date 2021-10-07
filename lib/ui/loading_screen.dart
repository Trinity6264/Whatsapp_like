import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/services/shared_prefs.dart';
import 'package:project1/ui/authentication.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  // initial loading method
  Future initialLoading(BuildContext context) {
    return Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return Authentication();
            },
          ),
        );
      },
    );
  }

  static final SharedPrefs _prefs = SharedPrefs.instance;

  @override
  Widget build(BuildContext context) {
    _prefs.retrieveData(context);
    initialLoading(context);
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                SizedBox(
                  height: 200,
                  child: Text(
                    'Whatsapp-Like',
                    style: GoogleFonts.almendra(
                      color: Colors.white,
                      fontSize: 50,
                    ),
                  ),
                ),
                CircularProgressIndicator(color: Colors.white),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
