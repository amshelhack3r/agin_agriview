import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:AgriView/utils/constants.dart';
import 'dart:convert';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map_location_picker/generated/i18n.dart'
    as location_picker;
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'api/api_provider.dart';
import 'models/message.dart';

class Farm extends StatefulWidget {
  @override
  _FarmState createState() => _FarmState();
}

class _FarmState extends State<Farm> {
  ApiProvider _apiProvider;
  Future<Message> _futureMessage;
  Map data = {};
  LocationResult _pickedLocation;
  double lon = 0.0;
  double lat = 0.0;

  TextEditingController _farmLocationController = new TextEditingController();
  TextEditingController _farmNameController = new TextEditingController();
  TextEditingController _acreageMappedController = new TextEditingController();
  TextEditingController _acreageApprovedController =
      new TextEditingController();
  TextEditingController _currentLandUseController = new TextEditingController();

  String _farmLocation;
  String _farmName;
  String _acreageMapped;
  String _acreageApproved;
  String _currentLandUse;
  String _farmerAginID;

  String dropdownValue = 'One';

  //input widget
  Widget _input(
      Icon icon, String hint, TextEditingController controller, bool obsecure) {
    int maxlength = 200;
    int minLine = 1;
    TextInputType textInputType = TextInputType.text;
    if (hint.compareTo("CURRENT LAND USE") == 0) {
      maxlength = 300;
      minLine = 4;
    } else if (hint.compareTo("ACREAGE MAPPED") == 0 ||
        hint.compareTo("ACREAGE APPROVED") == 0) {
      maxlength = 10;
      textInputType = TextInputType.number;
    }

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        keyboardType: textInputType,
        //maxLength: maxlength,
        controller: controller,
        obscureText: obsecure,
        //minLines: minLine,
        style: TextStyle(
          fontSize: 12,
          letterSpacing: 1.0,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
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

  void _registerFarm() {
    String _farmLocation;
    String _farmName;
    String _acreageMapped;
    String _acreageApproved;
    String _currentLandUse;

    _farmLocation = _farmLocationController.text;
    _farmName = _farmNameController.text;
    _acreageMapped = _acreageMappedController.text;
    _acreageApproved = _acreageApprovedController.text;
    _currentLandUse = _currentLandUseController.text;

    setState(() {
      _futureMessage = _apiProvider.createFarm(
          _farmName,
          _farmLocation,
          _acreageMapped,
          _acreageApproved,
          _currentLandUse,
          _farmerAginID,
          lat,
          lon);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiProvider = ApiProvider();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    _farmerAginID = data['farmerAginID'];

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
          title: Text('REGISTER FARM',
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
            child: (_futureMessage == null)
                ? Container(
                    child: ListView(
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Column(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 20,
                                top: 40,
                              ),
                              child: _input(Icon(Icons.account_circle),
                                  "FARM NAME", _farmNameController, false),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 20,
                              ),
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: <Widget>[
                                  _input(Icon(Icons.pin_drop), "FARM LOCATION",
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
                                        automaticallyAnimateToCurrentLocation:
                                            true,
                                        //mapStylePath: 'assets/mapStyle.json',
                                        myLocationButtonEnabled: true,
                                        layersButtonEnabled: true,
                                        //resultCardAlignment: Alignment.bottomCenter,
                                      );
                                      print("result = $result");
                                      setState(() {
                                        _pickedLocation = result;
                                        _farmLocationController.text =
                                            _pickedLocation.address;
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
                                bottom: 20,
                              ),
                              child: _input(
                                  Icon(Icons.outlined_flag),
                                  "ACREAGE MAPPED",
                                  _acreageMappedController,
                                  false),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 20,
                              ),
                              child: _input(
                                  Icon(Icons.flag),
                                  "ACREAGE APPROVED",
                                  _acreageApprovedController,
                                  false),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 20,
                              ),
                              child: _input(
                                  Icon(Icons.grain),
                                  "CURRENT LAND USE",
                                  _currentLandUseController,
                                  false),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 20,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                child: _button(
                                    "REGISTER",
                                    Colors.white,
                                    primary,
                                    primary,
                                    Colors.white,
                                    _registerFarm),
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
                  )
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: FutureBuilder<Message>(
                      future: _futureMessage,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Center(child: Text(snapshot.data.message));
                        } else if (snapshot.hasError) {
                          return Center(child: Text("${snapshot.error}"));
                        }

                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
