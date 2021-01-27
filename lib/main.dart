import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'injection.dart';
import 'route_generator.dart';
import 'state/db_provider.dart';
import 'state/user_provider.dart';

void main() async {
  //initilie my logger
  Fimber.plantTree(DebugTree(useColors: true));

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Fimber.i('setting up locators');

  await setupLocator();

  Fimber.i('finished setting up locators');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => DatabaseProvider()),
    ],
    child: MyApp(),
  ));
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
      initialRoute: '/SplashPage',
    );
  }
}
