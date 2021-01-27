import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/repository/api_repository.dart';
import '../state/db_provider.dart';
import '../state/user_provider.dart';
import '../utils/constants.dart';

class SplashWidget extends StatefulWidget {
  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  Future setup() async {
    var getIt = GetIt.instance;
    var _repository = getIt.get<ApiRepository>();
    var prefs = getIt.get<SharedPreferences>();

    var county = await _repository.fetchCounty();
    var modes = await _repository.fetchCultivationModes();
    var types = await _repository.fetchUnitTypes();

    context.read<DatabaseProvider>().county = county;
    context.read<DatabaseProvider>().modes = modes;
    context.read<DatabaseProvider>().unitType = types;

    if (prefs.containsKey(PREF_HAS_LOGGED_IN)) {
      var aginID = prefs.get(PREF_AGINID);
      var mobile = prefs.get(PREF_MOBILE);
      var name = prefs.get(PREF_NAME);

      Provider.of<UserProvider>(context, listen: false).defaultUser = {
        "fullname": name,
        "aginId": aginID,
        "mobile": mobile
      };
      Future.delayed(Duration(seconds: 3));
      return Navigator.pushNamed(context, '/HomePage');
    } else {
      return Navigator.pushNamed(context, '/AuthPage');
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        child: Stack(children: [
          Image.asset(
            "assets/images/splash.png",
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              "assets/images/agriview_logo.jpg",
              // height: 200,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        ]),
      ),
    );
  }
}
