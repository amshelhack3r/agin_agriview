import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map_location_picker/generated/i18n.dart' as location_picker;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Farmergroup extends StatefulWidget {
  @override
  _FarmergroupState createState() => _FarmergroupState();
}

class _FarmergroupState extends State<Farmergroup> {
  TextEditingController _farmergroupController = new TextEditingController();
  String _groupName;
  LocationResult _pickedLocation;
  double lon = 0.0;
  double lat = 0.0;
  TextEditingController _farmLocationController = new TextEditingController();

  //input widget
  Widget _input(Icon icon, String hint, TextEditingController controller,
      bool obsecure) {

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        keyboardType: TextInputType.text,
        //maxLength: 100,
        controller: controller,
        obscureText: obsecure,
        style: TextStyle(
            fontSize: 15,
            letterSpacing: 1.0
        ),
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
            hintText: hint,
            labelText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.grey[100],
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.grey[100],
                width: 1,
              ),
            ),
            prefixIcon: Padding(
              child: IconTheme(
                data: IconThemeData(color: Theme.of(context).primaryColor),
                child: icon,
              ),
              padding: EdgeInsets.only(left: 30, right: 10),
            )),
      ),
    );
  }

  //button widget
  Widget _button(String text, Color splashColor, Color highlightColor,
      Color fillColor, Color textColor, void function()) {
    return RaisedButton(
      highlightElevation: 0.0,
      splashColor: splashColor,
      highlightColor: highlightColor,
      elevation: 0.0,
      color: fillColor,
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: textColor, fontSize: 15),
      ),
      onPressed: () {
        function();
      },
    );
  }

  void _registerUser() {
    _groupName = _farmergroupController.text;
    _farmergroupController.clear();
  }


  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    return MaterialApp(
      localizationsDelegates: const [
        location_picker.S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en', ''),
        Locale('ar', ''),
      ],
      home: Scaffold(
        appBar: AppBar(
          title: Text('REGISTER FARMER GROUP',
              style: TextStyle(
                fontSize: 15.0,
              )),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          child: ClipRRect(
            /* borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),*/
            child: Container(
              child: ListView(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 10,
                          top: 20,
                        ),
                        child: _input(Icon(Icons.account_circle),
                            "GROUP NAME", _farmergroupController, false),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: <Widget>[
                            _input(Icon(Icons.pin_drop), "LOCATION",
                                _farmLocationController, false),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              color: Theme.of(context).primaryColor,
                              padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                              onPressed: () async {
                                LocationResult result =
                                await showLocationPicker(
                                  context,
                                  "AIzaSyCFYy2HHSUUYRuhyusmKhKFQEASoAyq1WE",
                                  initialCenter:
                                  LatLng(31.1975844, 29.9598339),
                                  automaticallyAnimateToCurrentLocation: true,
                                  //mapStylePath: 'assets/mapStyle.json',
                                  myLocationButtonEnabled: true,
                                  layersButtonEnabled: true,
                                  //resultCardAlignment: Alignment.bottomCenter,
                                );
                                print("result = $result");
                                setState((){
                                  _pickedLocation = result;
                                  _farmLocationController.text = _pickedLocation.address;
                                  lat = _pickedLocation.latLng.latitude;
                                  lon = _pickedLocation.latLng.longitude;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          child: _button("REGISTER", Colors.white, primary,
                              primary, Colors.white, _registerUser),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ]),
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );;
  }
}
