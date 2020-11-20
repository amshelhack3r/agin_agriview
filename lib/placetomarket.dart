import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:AgriView/dialog/dialogs.dart';
import 'package:AgriView/utils/AppUtil.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:AgriView/models/County.dart';
import 'package:AgriView/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;


int statusCode;

Future<List<CultivationMode>> fetchCultivationModeOptions() async {
  final response = await http.get(
    Uri.parse('${serverURL}market/cultivationmodes/list'),
    headers: <String, String>{
      'X-AGIN-API-Key-Token': APIKEY,
    },
  );
  print('result - ${response.body}');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<CultivationMode> listDropDowns;
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    listDropDowns = items.map<CultivationMode>((json) {
      return CultivationMode.fromJson(json);
    }).toList();

    return listDropDowns;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<List<ProduceStatus>> fetchProduceStatusOptions() async {
  final response = await http.get(
    Uri.parse('${serverURL}market/producestatus/list'),
    headers: <String, String>{
      'X-AGIN-API-Key-Token': APIKEY,
    },
  );
print('status - ${response.body}');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<ProduceStatus> listDropDowns;
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    listDropDowns = items.map<ProduceStatus>((json) {
      return ProduceStatus.fromJson(json);
    }).toList();

    return listDropDowns;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<List<UnitType>> fetchUnitTypeOptions() async {
  final response = await http.get(
    Uri.parse('${serverURL}market/unittypes/list'),
    headers: <String, String>{
      'X-AGIN-API-Key-Token': APIKEY,
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<UnitType> listDropDowns;
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    listDropDowns = items.map<UnitType>((json) {
      return UnitType.fromJson(json);
    }).toList();

    return listDropDowns;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<Message> createPlacetoMarket (
    String farmerAginID,
    String landAginID,
    String cultivationMode,
    String produceStatus,
    String unitType,
    String pricePerUnitType,
    String readyFromDate,
    String agronomyAginID,
    String quantityAvailable,
    String phototext,
    String fileExtension,
    String productID) async {

  print('photoextension $phototext $fileExtension');

  final http.Response response = await http.post(
    Uri.parse('${serverURL}market/add/produce'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'X-AGIN-API-Key-Token': APIKEY,
    },
    body: jsonEncode(<String, String>{
      'farmerAginID': farmerAginID,
      'landAginID': landAginID,
      'cultivationMode': cultivationMode,
      'produceStatus': produceStatus,
      'unitType': unitType,
      'pricePerUnitType': pricePerUnitType,
      'readyFromDate': readyFromDate,
      'agronomyAginID': agronomyAginID,
      'quantityAvailable': quantityAvailable,
      'phototext': phototext,
      'fileExtension': fileExtension,
      'productID': productID,
    }),
  );

  statusCode = response.statusCode;
  print('response ${response.body}');
  if (response.statusCode == 201) {
    return Message.fromJson(json.decode(response.body));
  } else {
    return Message.fromJson(json.decode(response.body));
  }
}

class Message {
  final String message;
  final String responsecode;

  Message({this.message, this.responsecode});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      responsecode: json['responsecode'],
    );
  }
}

class UnitTypeList {
  final List<UnitType> unitTypeList;

  UnitTypeList({this.unitTypeList});

  factory UnitTypeList.fromJson(Map<String, dynamic> json) {
    return UnitTypeList(
      unitTypeList: json['unitTypes'],
    );
  }
}

class UnitType {
  final int unitTypeID;
  final String unitTypeName;

  UnitType({this.unitTypeID, this.unitTypeName});

  factory UnitType.fromJson(Map<String, dynamic> json) {
    return UnitType(
      unitTypeID: json['unitTypeID'],
      unitTypeName: json['unitTypeName'],
    );
  }
}

class CultivationMode {
  final int id;
  final String modeDescription;

  CultivationMode({this.id, this.modeDescription});

  factory CultivationMode.fromJson(Map<String, dynamic> json) {
    return CultivationMode(
      id: json['id'],
      modeDescription: json['modeDescription'],
    );
  }
}

class ProduceStatus {
  final int id;
  final String statusDecription;

  ProduceStatus({this.id, this.statusDecription});

  factory ProduceStatus.fromJson(Map<String, dynamic> json) {
    return ProduceStatus(
      id: json['id'],
      statusDecription: json['statusDecription'],
    );
  }
}

class StatusDesription {
  final int id;
  final String statusDescription;

  StatusDesription({this.id, this.statusDescription});

  factory StatusDesription.fromJson(Map<String, dynamic> json) {
    return StatusDesription(
      id: json['id'],
      statusDescription: json['statusDescription'],
    );
  }
}

class DropDowns {
  //final UnitType unitType;
  final CultivationMode cultivationModes;
  /*final ProduceStatus produceStatus;
  final StatusDesription statusDesription;*/

  DropDowns(this.cultivationModes);

  factory DropDowns.fromJson(Map<String, dynamic> json) {
    return DropDowns(
        //UnitType.fromJson(json['unitTypes'])
        CultivationMode.fromJson(json['cultivationModes'])
        /*ProduceStatus.fromJson(json['produceStatuses']),
      StatusDesription.fromJson(json['placeMarketStatus']),*/
        );
  }
}

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


  Future getImage() async{
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });

  }

  @override
  void initState() {
    super.initState();
    futureCultivationModeDropDowns = fetchCultivationModeOptions();
    futureUnitTypeDropDowns = fetchUnitTypeOptions();
    futureProduceStatusDropDowns = fetchProduceStatusOptions();

    /*getCountiesList().then((listMap){
      listMap.map((map) {
        return getDropDownWidget(map);
      }).forEach((dropDownItem) {
          list.add(dropDownItem);
      });
       setState((){

       });
    });*/
  }

  //input widget
  Widget _input(
      Icon icon, String hint, TextEditingController controller, bool obsecure) {

    TextInputType textInputType = TextInputType.text;
    if (hint.compareTo("Unit Type Quantity Available") == 0 ) {
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
      child: (_isLoadingButton) ?
      Container(
        width: 19,
        height: 19,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      )
    :
      Text(
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

  void _registerProduceToMarket() async{
    _price = _priceController.text;
    _readyFromDate = _readyFromDateController.text;
    _quantity = _quantityController.text;
    var newExtension;

    await AppUtil.getFileExtension(_image).then((result){
      newExtension = result;
      setState(() {
        _fileExtension = result;
        _isLoadingButton = !_isLoadingButton;
      });

    }).catchError((error){
    },test: (err){});
    await AppUtil.getImageAsBase64(_image).then((result){
      setState(() {
        _photoText = result;
      });
    }).catchError((error){
      print(error);
    },test: (err){});

    setState(() {
      _enableButton = false;
      _isLoadingButton = true;

      _futureMessage = createPlacetoMarket(
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
          _productID).then((value){

        FocusScope.of(context).requestFocus(new FocusNode());
        Timer(Duration(milliseconds: 4000), () {
          setState(() {
            _isLoadingButton = false;
            _enableButton = true;
          });
        });

        Message message = value;
        if(statusCode == 201){
          //_scaffoldKey.currentState.showSnackBar(
            //  SnackBar(content: Text(message.message)));
          Future<DialogAction> action = Dialogs.messageDialog(context, "info", message.message);
          action.then((value){
            if(value == DialogAction.yes){
              Map map = {'landAginID':_landAginID, 'name' : _name, 'farmerAginID':_farmerAginID, 'aggregatorAginID':_aggregatorAginID};
              Navigator.popAndPushNamed(context, '/producelist',arguments: map);
            }
          });
        }else{
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text(message.message)));
        }
        return;
      });
    });
  }

  List<County> parseCounties(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    List<County> lc =
        parsed.map<County>((json) => County.fromJson(json)).toList();
    print('parsed${parsed} ${lc.length}');
    return lc;
  }

  Future<List<County>> _getCountiesList() async {
    HttpClient client = new HttpClient();
    List<County> conList;
    await client
        .getUrl(Uri.parse('${serverURL}county/list'))
        .then((HttpClientRequest request) {
      request.headers.add("X-AGIN-API-Key-Token", APIKEY);
      return request.close();
    }).then((HttpClientResponse response) {
      // Process the response.
      response.transform(utf8.decoder).listen((contents) {
        // handle data
        //List<dynamic> datalist = jsonDecode(contents);
        //return County.fromMap(jsonDecode(contents));

        conList = parseCounties(contents);

        print('connlist$conList');

        return conList;

        //countyList = new List(datalist.length);
        /*datalist.map((map) {
            return getDropDownWidget(map);
          }).forEach((dropDownItem) {
            list.add(dropDownItem);
          });
          setState((){

          });*/
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
                            padding: EdgeInsets.only(
                              bottom: 20,
                              top: 30
                            ),
                            child: _input(
                                null,
                                "QUANTITY AVAILABLE",
                                _quantityController,
                                false
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 20,
                            ),
                            child: _input(
                                null,
                                "UNIT PRICE",
                                _priceController,
                                false
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20.0,0,0,10),
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
                                                MediaQuery.of(context).size.width/2.3,
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
                                    padding: const EdgeInsets.fromLTRB(0,0,0,10),
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
                                                    MediaQuery.of(context).size.width/2.3,
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
                                                      hintText:
                                                          '',
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
                                padding: const EdgeInsets.fromLTRB(20.0,0,0,10),
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
                                            width:
                                                MediaQuery.of(context).size.width,
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
                                              value: selectedProduceStatus,
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
                                                          ProduceStatus>>(
                                                  (ProduceStatus produceStatus) {
                                                return DropdownMenuItem<
                                                        ProduceStatus>(
                                                    value: produceStatus,
                                                    child: Text(
                                                      produceStatus
                                                          .statusDecription,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 16,
                                                          letterSpacing: 1.0,
                                                          backgroundColor:
                                                              Colors.white10),
                                                    ));
                                              }).toList(),
                                              onChanged: (ProduceStatus newValue) {
                                                setState(() =>
                                                    selectedProduceStatus =
                                                        newValue);
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
                                      padding: const EdgeInsets.fromLTRB(10.0,2.5,2.5,2.5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        child: GestureDetector(
                                          onTap: (){
                                            getImage();
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              _image == null ? Icon(Icons.camera_alt,color: Colors.grey,) : Image.file(_image, fit: BoxFit.fitHeight),
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
                                            padding: const EdgeInsets.fromLTRB(0,0,30,10),
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
                                                  padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                                                  onPressed: () async {
                                                    DatePicker.showDatePicker(context,
                                                        showTitleActions: true,
                                                        theme: DatePickerTheme(
                                                            headerColor: Colors.orange,
                                                            backgroundColor: Colors.blue,
                                                            itemStyle: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14),
                                                            doneStyle: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 14)),
                                                        onChanged: (date) {
                                                          _readyFromDateController.text = '${date.year}-${date.month}-${date.day}';
                                                        }, onConfirm: (date) {
                                                          _readyFromDateController.text = '${date.year}-${date.month}-${date.day}';
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
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Container(
                              child: _button("REGISTER", Colors.white, primary,
                                  primary, Colors.white, _registerProduceToMarket),
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
        ),
      ),
    );
    ;
  }
}

class Post {
  final List<dynamic> county;

  Post({this.county});

  factory Post.fromJson(Map<dynamic, dynamic> json) {
    return Post(
      county: json['county'],
    );
  }
}
