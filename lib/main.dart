import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_theme.dart';

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
      theme: getThemeData(),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/AuthPage',
    );
  }
}
