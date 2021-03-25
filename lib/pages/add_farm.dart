import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
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
  var acresMappedController = TextEditingController();
  var acresApprovedController = TextEditingController();
  LatLng _latLon;
  bool isValid = true;
  String farmNameError;
  String farmLocationError;
  String farmUseError;
  String acresMappedError;
  String acresApprovedError;

  bool isShown = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Future<Position> _getPosition;

  bool serviceEnabled;
  LocationPermission permission;

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _getPosition = init();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

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
        key: _scaffoldKey,
        appBar: AppBar(),
        body: SafeArea(
          child: Container(
            color: Colors.white70,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                _showMap(),
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
        ));
  }

  Widget _buildForm() {
    TextStyle _style = TextStyle(fontSize: 12);
    return Material(
      elevation: 20,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Farm Details".toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
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
                  labelStyle: _style,
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
                          Text(
                              "lat ${double.parse(_latLon.latitude.toStringAsFixed(3))}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor)),
                          Text(
                              "lon ${double.parse(_latLon.longitude.toStringAsFixed(3))}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor)),
                        ],
                      ),
                    ),
              SizedBox(
                height: 10,
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
                        labelStyle: _style,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                    onPressed: () {
                      setState(() {
                        isShown = false;
                      });

                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("Long Press to set location"),
                      ));
                    },
                    child: Text(
                      'Map',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
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
                  labelStyle: _style,
                  hintText: "eg Agricultural",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: acresMappedController,
                        onEditingComplete: () {
                          setState(() {
                            acresMappedError = null;
                          });
                        },
                        decoration: InputDecoration(
                            errorText: isValid ? null : acresMappedError,
                            labelText: "Acres Mapped",
                            labelStyle: _style,
                            hintText: "eg 10 acres",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            suffix: Text("acres")),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: acresApprovedController,
                        onEditingComplete: () {
                          setState(() {
                            acresApprovedError = null;
                          });
                        },
                        decoration: InputDecoration(
                            errorText: isValid ? null : acresApprovedError,
                            labelText: "Acres Approved",
                            labelStyle: _style,
                            hintText: "eg 10 acres",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            suffix: Text("acres")),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              isLoading
                  ? RaisedButton(
                      onPressed: null,
                      disabledColor: Colors.grey,
                      elevation: 10,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () => _validate(),
                      child: Text(
                        'ADD FARM',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w800),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showMap() {
    return FutureBuilder(
        future: _getPosition,
        builder: (context, AsyncSnapshot<Position> snapshot) {
          if (snapshot.hasData) {
            var _position = snapshot.data;
            return GoogleMap(
              onMapCreated: _onMapCreated,
              onLongPress: (latLong) {
                setState(() {
                  _latLon = latLong;
                  isShown = true;
                });
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(_position.latitude, _position.longitude),
                  zoom: 14),
            );
          } else if (snapshot.hasError) {
            var err = snapshot.error;
            if (err is DioError) {
              Future.delayed(Duration(milliseconds: 1),
                  () => Dialogs.messageDialog(context, true, err.message));
            }
            return Container();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
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
    if (acresMappedController.text.isEmpty) {
      setState(() {
        isValid = false;
        acresMappedError = "This cannot be empty!";
        isLoading = false;
      });
      return;
    }
    if (acresApprovedController.text.isEmpty) {
      setState(() {
        isValid = false;
        acresApprovedError = "This cannot be empty!";
        isLoading = false;
      });
      return;
    }

    Map params = {
      "acreageMapped": int.parse(acresMappedController.text),
      "acreageApproved": int.parse(acresApprovedController.text),
      "farmName": farmNameController.text,
      "farmLocation": farmLocationController.text,
      "currentLandUse": farmUseController.text,
      "producerAginId": widget.farmer.userAginID,
      "lat": _latLon.latitude,
      "lon": _latLon.longitude
    };
    try {
      if (await getIt.get<ApiRepository>().addFarm(params)) {
        Navigator.pushNamed(context, '/FarmerInfo', arguments: widget.farmer);
      }
    } catch (e) {
      if (e is DioError) {
        Dialogs.messageDialog(context, true, e.message);
      }
    }
  }
}
