import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../core/repository/api_repository.dart';
import '../injection.dart';
import '../models/farmer_info.dart';
import '../state/db_provider.dart';
import 'elements/dialogs.dart';

class AddFarm extends StatefulWidget {
  final FarmerInfo farmer;
  const AddFarm({Key key, this.farmer}) : super(key: key);

  @override
  _AddFarmState createState() => _AddFarmState();
}

class _AddFarmState extends State<AddFarm> {
  bool isLoading = false;
  var farmNameController = TextEditingController();
  var farmLocationController = TextEditingController();
  var farmUseController = TextEditingController();
  LatLng _latLon;
  bool isValid = true;
  String farmNameError;
  String farmLocationError;
  String farmUseError;
  bool isShown = true;
  GlobalKey<ScaffoldMessengerState> _scaffoldMessangerKey = GlobalKey();

  bool serviceEnabled;
  LocationPermission permission;

  Completer<GoogleMapController> _controller = Completer();

  Future<Position> init() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScaffoldMessenger(
      key: _scaffoldMessangerKey,
      child: SafeArea(
        child: Container(
          color: Colors.white70,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              FutureBuilder(
                  future: init(),
                  builder: (context, AsyncSnapshot<Position> snapshot) {
                    if (snapshot.hasData) {
                      var _position = snapshot.data;
                      return GoogleMap(
                        mapType: MapType.hybrid,
                        initialCameraPosition: CameraPosition(
                          target:
                              LatLng(_position.latitude, _position.longitude),
                          zoom: 14,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        onLongPress: (LatLng pos) {
                          setState(() {
                            _latLon = pos;
                            isShown = true;
                          });
                        },
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      return Container();
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
              isShown
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildForm(),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    )
        // MapboxMap(
        //   accessToken: MAPBOX_TOKEN,
        //   initialCameraPosition: CameraPosition(
        //     zoom: 15.0,
        //     target: LatLng(14.508, 46.048),
        //   ),
        // ),
        );
  }

  _buildForm() {
    return Material(
      elevation: 20,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18.0),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Farm Details".toUpperCase(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                onEditingComplete: () {
                  setState(() {
                    farmNameError = null;
                  });
                },
                keyboardType: TextInputType.text,
                controller: farmNameController,
                decoration: InputDecoration(
                  errorText: isValid ? null : farmNameError,
                  labelText: "Farm Name",
                  hintText: "eg Steve Nakuru Farm",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              (_latLon == null)
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("lat ${_latLon.latitude.toString()}"),
                          Text("lon ${_latLon.longitude.toString()}"),
                        ],
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: TextField(
                      controller: farmLocationController,
                      onEditingComplete: () {
                        setState(() {
                          farmLocationError = null;
                        });
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        errorText: isValid ? null : farmLocationError,
                        labelText: "Farm Location",
                        hintText: "eg Nakuru",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    elevation: 10,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    onPressed: () {
                      setState(() {
                        isShown = false;
                      });

                      _scaffoldMessangerKey.currentState.showSnackBar(SnackBar(
                        content: Text("Long Press to set location"),
                      ));
                    },
                    child: Text(
                      'Map',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: farmUseController,
                onEditingComplete: () {
                  setState(() {
                    farmUseError = null;
                  });
                },
                decoration: InputDecoration(
                  errorText: isValid ? null : farmUseError,
                  labelText: "Land Use",
                  hintText: "eg Agricultural",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              isLoading
                  ? RaisedButton(
                      onPressed: null,
                      disabledColor: Colors.grey,
                      elevation: 10,
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    )
                  : RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      elevation: 10,
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () => _validate(),
                      child: Text(
                        'ADD FARM',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  String _randomCounty() {
    var counties = context.watch<DatabaseProvider>().county;
    var random = Random();
    var county = counties[random.nextInt(4)];
    return county.countyName;
  }

  _validate() async {
    setState(() {
      isLoading = true;
    });
    if (farmNameController.text.isEmpty) {
      setState(() {
        isValid = false;
        farmNameError = "This cannot be empty!";
        isLoading = false;
      });
      return;
    }
    if (farmLocationController.text.isEmpty) {
      setState(() {
        isValid = false;
        farmLocationError = "This cannot be empty!";
        isLoading = false;
      });
      return;
    }
    if (farmUseController.text.isEmpty) {
      setState(() {
        isValid = false;
        farmUseError = "This cannot be empty!";
        isLoading = false;
      });
      return;
    }

    Map params = {
      "acreageMapped": 10,
      "acreageApproved": 10,
      "farmName": farmNameController.text,
      "farmLocation": farmLocationController.text,
      "currentLandUse": farmUseController.text,
      "producerAginId": widget.farmer.userAginID,
      "lat": "-1.17139",
      "lon": "36.83556"
    };
    try {
      if (await getIt.get<ApiRepository>().addFarm(params)) {
        Navigator.pop(context);
      }
    } catch (e) {
      Dialogs.messageDialog(context, true, e.toString());
    }
  }
}
