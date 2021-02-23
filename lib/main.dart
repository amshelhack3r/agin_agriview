import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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

  //setup Sentry for bug issues
  await Sentry.init(
    (options) {
      options.dsn =
          'https://c2e6ad1ae6d040428d5c11dfebd9c70d@o509370.ingest.sentry.io/5603735';
    },
    appRunner: () => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
      ],
      child: MyApp(),
    )),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: getIt.get<ValueNotifier<GraphQLClient>>(),
      child: MaterialApp(
        title: 'Agin Farmer',
        debugShowCheckedModeBanner: false,
        theme: getThemeData(),
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: '/SplashPage',
      ),
    );
  }
}
