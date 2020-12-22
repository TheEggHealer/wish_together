import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wishtogether/screens/screen_wrapper.dart';
import 'package:wishtogether/screens/splash_screen.dart';

void main() {
  runApp(WishTogether());
}

class WishTogether extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//test
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          //Something went wrong
          return Container(color: Colors.red);
        } else if(snapshot.connectionState == ConnectionState.done) {
          return ScreenWrapper();
        }
        return SplashScreen();
      },
    );
  }

}
