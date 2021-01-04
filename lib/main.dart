import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'route_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agin Farmer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          hintColor: new Color(0xff0ad7cb),
          primaryColor: new Color(0xff12a89f),
          primaryColorDark: Color(0xff1d8a84),
          primaryColorLight: Color(0xff0ad7cb),
          fontFamily: "Montserrat",
          canvasColor: Colors.white),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/SplashPage',
    );
  }
}
