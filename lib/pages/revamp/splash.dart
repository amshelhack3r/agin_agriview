import 'package:AgriView/pages/revamp/login.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SplashScreen(
            seconds: 14,
            navigateAfterSeconds: LoginPage(),
            title: Text('Welcome In SplashScreen'),
            image: Image.asset('assets/images/agriview_logo.jpg'),
            backgroundColor: Colors.white,
            styleTextUnderTheLoader: new TextStyle(),
            photoSize: 100.0,
            loaderColor: Colors.red));
  }
}
