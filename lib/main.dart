import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project1/models/current_user_model.dart';
import 'package:project1/services/custom_firebase.dart';
import 'package:project1/ui/loading_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  // the [WidgetsFlutterBinding.ensureInitialized()] is use to communicate to
  // firebase and flutter engine and also to make the screen orientation portrait vetically
  // static before [runApp] function fires.
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    //this line prints the default flutter gesture caught exception in console
    //FlutterError.dumpErrorToConsole(details);
    print("Error From INSIDE FRAME_WORK");
    print("----------------------");
    print("Error :  ${details.exception}");
    print("StackTrace :  ${details.stack}");
  };
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'Project 1';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CustomFirebase.instance,
        ),
        StreamProvider<CurrentUserModel?>.value(
          value: CustomFirebase.instance.currentUser,
          initialData: CurrentUserModel(
              displayName: '', photoUrl: '', email: '', userId: ''),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: _title,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LoadingScreen(),
      ),
    );
  }
}
