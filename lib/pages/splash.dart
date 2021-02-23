import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/repository/api_repository.dart';
import '../injection.dart';
import '../state/db_provider.dart';
import '../state/user_provider.dart';
import '../utils/constants.dart';

class SplashWidget extends StatefulWidget {
  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  Future<bool> setup() async {
    var _repository = getIt.get<ApiRepository>();
    var prefs = getIt.get<SharedPreferences>();

    var modes = await _repository.fetchCultivationModes();
    var types = await _repository.fetchUnitTypes();
    var county = await _repository.fetchCounty();

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
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: setup(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              var hasLoggedIn = snapshot.data;
              if (hasLoggedIn) {
                Future.delayed(Duration(milliseconds: 1),
                    () => Navigator.pushReplacementNamed(context, '/HomePage'));
              } else {
                Future.delayed(Duration(milliseconds: 1),
                    () => Navigator.pushReplacementNamed(context, '/AuthPage'));
              }
              return Container();
            } else if (snapshot.hasError) {
              return Container(
                height: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/wifi_off.png",
                      // width: 200,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "No Internet, \n Switch to internet and retry",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, '/SplashPage'),
                        icon: Icon(Icons.refresh),
                        label: Text("RETRY"))
                  ],
                ),
              );
            } else {
              return Container(
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
              );
            }
          },
        ),
      ),
    );
  }
}
