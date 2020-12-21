import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../api/api_provider.dart';
import '../models/County.dart';
import '../models/cultivation_mode.dart';
import '../models/message.dart';
import '../models/produce_status.dart';
import '../models/status_description.dart';
import '../models/unit_type.dart';
import '../utils/AppUtil.dart';
import 'elements/dialogs.dart';

class PlaceToMarket extends StatefulWidget {
  @override
  _PlaceToMarketState createState() => _PlaceToMarketState();
}

class _PlaceToMarketState extends State<PlaceToMarket> {
  Future<List<CultivationMode>> futureCultivationModeDropDowns;
  Future<List<UnitType>> futureUnitTypeDropDowns;
  Future<List<ProduceStatus>> futureProduceStatusDropDowns;
  Future<Message> _futureMessage;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoadingButton = false;
  bool _enableButton = false;
  ApiProvider _apiProvider;

  Map data = {};
  List<DropdownMenuItem<County>> list;
  Future<List<County>> fCountyList;
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _readyFromDateController = new TextEditingController();
  TextEditingController _quantityController = new TextEditingController();

  String _price;
  String _readyFromDate;
  String _quantity;
  String _photoText = "";
  String _fileExtension = "";
  String _productID;
  String _uuid;
  String _farmerAginID;
  String _aggregatorAginID;
  String _landAginID;
  String _name;
  bool _obsecure = false;
  File _image;

  UnitType selectedUnitType;
  CultivationMode selectedCultivationMode;
  ProduceStatus selectedProduceStatus;
  StatusDesription selectedStatusDesription;

  Future getImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    _apiProvider = ApiProvider();
    futureCultivationModeDropDowns = _apiProvider.fetchCultivationModeOptions();
    futureUnitTypeDropDowns = _apiProvider.fetchUnitTypeOptions();
    futureProduceStatusDropDowns = _apiProvider.fetchProduceStatusOptions();
  }

  //input widget
  Widget _input(
      Icon icon, String hint, TextEditingController controller, bool obsecure) {
    TextInputType textInputType = TextInputType.text;
    if (hint.compareTo("Unit Type Quantity Available") == 0) {
      textInputType = TextInputType.number;
    }

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        keyboardType: textInputType,
        controller: controller,
        obscureText: obsecure,
        style: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 14, letterSpacing: 1.0),
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
        ),
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
      child: (_isLoadingButton)
          ? Container(
              width: 19,
              height: 19,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: textColor, fontSize: 12),
            ),
      onPressed: () {
        _enableButton = true;
        _enableButton ? function() : null;
      },
    );
  }

  void _registerProduceToMarket() async {
    _price = _priceController.text;
    _readyFromDate = _readyFromDateController.text;
    _quantity = _quantityController.text;
    var newExtension;

    await AppUtil.getFileExtension(_image).then((result) {
      newExtension = result;
      setState(() {
        _fileExtension = result;
        _isLoadingButton = !_isLoadingButton;
      });
    }).catchError((error) {}, test: (err) {});
    await AppUtil.getImageAsBase64(_image).then((result) {
      setState(() {
        _photoText = result;
      });
    }).catchError((error) {
      print(error);
    }, test: (err) {});

    setState(() {
      _enableButton = false;
      _isLoadingButton = true;

      _futureMessage = _apiProvider
          .createPlacetoMarket(
              _farmerAginID,
              _landAginID,
              selectedCultivationMode.id.toString(),
              selectedProduceStatus.id.toString(),
              selectedUnitType.unitTypeID.toString(),
              _price,
              _readyFromDate,
              _aggregatorAginID,
              _quantity,
              _photoText,
              _fileExtension,
              _productID)
          .then((value) {
        FocusScope.of(context).requestFocus(new FocusNode());
        Timer(Duration(milliseconds: 4000), () {
          setState(() {
            _isLoadingButton = false;
            _enableButton = true;
          });
        });

        //_scaffoldKey.currentState.showSnackBar(
        //  SnackBar(content: Text(message.message)));
        Future<DialogAction> action =
            Dialogs.messageDialog(context, "info", value.message);
        action.then((value) {
          if (value == DialogAction.yes) {
            Map map = {
              'landAginID': _landAginID,
              'name': _name,
              'farmerAginID': _farmerAginID,
              'aggregatorAginID': _aggregatorAginID
            };
            Navigator.popAndPushNamed(context, '/producelist', arguments: map);
          }
        });
        return;
      }).catchError((error) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    //get the variables
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    _aggregatorAginID = data['aggregatorAginID'];
    _productID = data['id'];
    _uuid = data['uuid'];
    _farmerAginID = data['farmerAginID'];
    _aggregatorAginID = data['aggregatorAginID'];
    _landAginID = data['landAginID'];
    _name = data['name'];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('PLACE TO MARKET',
            style: TextStyle(
              fontSize: 15.0,
            )),
        centerTitle: true,
        elevation: 0,
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
                    padding: EdgeInsets.only(bottom: 20, top: 30),
                    child: _input(
                        null, "QUANTITY AVAILABLE", _quantityController, false),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: _input(null, "UNIT PRICE", _priceController, false),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 10),
                            child: Text("UNIT TYPE"),
                          ),
                          FutureBuilder<List<UnitType>>(
                              future: futureUnitTypeDropDowns,
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return CircularProgressIndicator();
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return CircularProgressIndicator();
                                  case ConnectionState.done:
                                    print('hasdata${snapshot.hasData}');
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 20, left: 20, right: 0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.3,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                            width: 1.0,
                                            style: BorderStyle.solid,
                                            color: Colors.grey[100],
                                          ),
                                        ),
                                        child: DropdownButton<UnitType>(
                                          /*deco: InputDecoration(
                                                      fillColor: Colors.white,
                                                      floatingLabelBehavior:
                                                      FloatingLabelBehavior.auto,
                                                      hintStyle: TextStyle(
                                                          fontWeight: FontWeight.normal,
                                                          fontSize: 14),
                                                      hintText: '',
                                                      //labelText: 'COUNTY',
                                                      enabledBorder: InputBorder.none,
                                                      icon: Padding(
                                                        padding:
                                                        const EdgeInsets.fromLTRB(
                                                            0, 0, 0, 0),

                                                      )),*/
                                          value: selectedUnitType,
                                          //hint: Text('SELECT COUNTY'),
                                          icon: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 8, 0),
                                            child: Icon(
                                              Icons.arrow_drop_down_circle,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          isExpanded: true,
                                          iconSize: 30,
                                          elevation: 16,
                                          items: snapshot.data
                                              .map<DropdownMenuItem<UnitType>>(
                                                  (UnitType unitType) {
                                            return DropdownMenuItem<UnitType>(
                                                value: unitType,
                                                child: Text(
                                                  unitType.unitTypeName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14,
                                                      letterSpacing: 1.0,
                                                      backgroundColor:
                                                          Colors.white10),
                                                ));
                                          }).toList(),
                                          onChanged: (UnitType newValue) {
                                            setState(() =>
                                                selectedUnitType = newValue);
                                            // selectedCountry = newValue;
                                            print(newValue.unitTypeName);
                                            print(newValue.unitTypeID);
                                          },
                                        ),
                                      ),
                                    );

                                  default:
                                    return CircularProgressIndicator();
                                }
                              }),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Text("CULTIVATION MODE"),
                          ),
                          FutureBuilder<List<CultivationMode>>(
                              future: futureCultivationModeDropDowns,
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return CircularProgressIndicator();
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return CircularProgressIndicator();
                                  case ConnectionState.done:
                                    print('hasdata${snapshot.hasData}');
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 20, left: 0, right: 20),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.3,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                            width: 1.0,
                                            style: BorderStyle.solid,
                                            color: Colors.grey[100],
                                          ),
                                        ),
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.auto,
                                              hintStyle: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14),
                                              hintText: '',
                                              //labelText: 'COUNTY',
                                              enabledBorder: InputBorder.none,
                                              icon: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 0),
                                              )),
                                          value: selectedCultivationMode,
                                          //hint: Text('SELECT COUNTY'),
                                          icon: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 8, 0),
                                            child: Icon(
                                              Icons.arrow_drop_down_circle,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          isExpanded: true,
                                          iconSize: 30,
                                          elevation: 16,
                                          items: snapshot.data.map<
                                                  DropdownMenuItem<
                                                      CultivationMode>>(
                                              (CultivationMode
                                                  cultivationMode) {
                                            return DropdownMenuItem<
                                                    CultivationMode>(
                                                value: cultivationMode,
                                                child: Text(
                                                  cultivationMode
                                                      .modeDescription,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 16,
                                                      letterSpacing: 1.0,
                                                      backgroundColor:
                                                          Colors.white10),
                                                ));
                                          }).toList(),
                                          onChanged:
                                              (CultivationMode newValue) {
                                            setState(() =>
                                                selectedCultivationMode =
                                                    newValue);
                                            // selectedCountry = newValue;
                                            print(newValue.modeDescription);
                                            print(newValue.id);
                                          },
                                        ),
                                      ),
                                    );

                                  default:
                                    return CircularProgressIndicator();
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 10),
                        child: Text("PRODUCE STATUS"),
                      ),
                      FutureBuilder<List<ProduceStatus>>(
                          future: futureProduceStatusDropDowns,
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return CircularProgressIndicator();
                              case ConnectionState.active:
                              case ConnectionState.waiting:
                                return CircularProgressIndicator();
                              case ConnectionState.done:
                                print('hasdata${snapshot.hasData}');
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20, left: 20, right: 20),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        width: 1.0,
                                        style: BorderStyle.solid,
                                        color: Colors.grey[100],
                                      ),
                                    ),
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          hintStyle: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                          hintText: '',
                                          //labelText: 'COUNTY',
                                          enabledBorder: InputBorder.none,
                                          icon: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                          )),
                                      value: selectedProduceStatus,
                                      //hint: Text('SELECT COUNTY'),
                                      icon: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 8, 0),
                                        child: Icon(
                                          Icons.arrow_drop_down_circle,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      isExpanded: true,
                                      iconSize: 30,
                                      elevation: 16,
                                      items: snapshot.data
                                          .map<DropdownMenuItem<ProduceStatus>>(
                                              (ProduceStatus produceStatus) {
                                        return DropdownMenuItem<ProduceStatus>(
                                            value: produceStatus,
                                            child: Text(
                                              produceStatus.statusDecription,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                  letterSpacing: 1.0,
                                                  backgroundColor:
                                                      Colors.white10),
                                            ));
                                      }).toList(),
                                      onChanged: (ProduceStatus newValue) {
                                        setState(() =>
                                            selectedProduceStatus = newValue);
                                        // selectedCountry = newValue;
                                        print(newValue.statusDecription);
                                        print(newValue.id);
                                      },
                                    ),
                                  ),
                                );

                              default:
                                return CircularProgressIndicator();
                            }
                          }),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Container(
                      //height: 200.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 2.5, 2.5, 2.5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    getImage();
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      _image == null
                                          ? Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey,
                                            )
                                          : Image.file(_image,
                                              fit: BoxFit.fitHeight),
                                      Text(
                                        'Produce Photo',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 2.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 30, 10),
                                    child: Text("DATE READY"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 20,
                                    ),
                                    child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: <Widget>[
                                        _input(null, "",
                                            _readyFromDateController, false),
                                        IconButton(
                                          icon: Icon(Icons.calendar_today),
                                          color: Theme.of(context).primaryColor,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 30, 0),
                                          onPressed: () async {
                                            DatePicker.showDatePicker(context,
                                                showTitleActions: true,
                                                theme: DatePickerTheme(
                                                    headerColor: Colors.orange,
                                                    backgroundColor:
                                                        Colors.blue,
                                                    itemStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                    doneStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14)),
                                                onChanged: (date) {
                                              _readyFromDateController.text =
                                                  '${date.year}-${date.month}-${date.day}';
                                            }, onConfirm: (date) {
                                              _readyFromDateController.text =
                                                  '${date.year}-${date.month}-${date.day}';
                                            },
                                                currentTime: DateTime.now(),
                                                locale: LocaleType.en);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20,
                        left: 20,
                        right: 20,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      child: _button("REGISTER", Colors.white, primary, primary,
                          Colors.white, _registerProduceToMarket),
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
        )),
      ),
    );
    ;
  }
}
