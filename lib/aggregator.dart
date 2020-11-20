import 'dart:convert';
import 'dart:io';
import 'package:AgriView/dialog/dialogs.dart';
import 'package:AgriView/otp.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:AgriView/models/County.dart';
import 'package:AgriView/utils/constants.dart';

Future<List<Country>> fetchCountries() async {
  final response = await http.get(
    Uri.parse('${serverURL}country/list'),
    headers: <String, String>{
      'X-AGIN-API-Key-Token': APIKEY,
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Country> listCountries = items.map<Country>((json) {
      return Country.fromJson(json);
    }).toList();
    return listCountries;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<List<Album>> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('${serverURL}county/list'),
    headers: <String, String>{
      'X-AGIN-API-Key-Token': APIKEY,
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Album> listAlbums = items.map<Album>((json) {
      return Album.fromJson(json);
    }).toList();
    return listAlbums;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

int statusCode;
Future<Message> createAggregator(String firstName, String lastName,
    String email, String phone, String county, String password, String organizationCode) async {
  final http.Response response = await http.post(
    Uri.parse('${serverURL}aggregator/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'X-AGIN-API-Key-Token': APIKEY,
    },
    body: jsonEncode(<String, String>{
      'FirstName': firstName,
      'LastName': lastName,
      'PhoneNumber': phone,
      'EmailAddress': email,
      'CountyID': county,
      'Password': password,
      'organizationCode': organizationCode,
    }
    ),
  );

  statusCode = response.statusCode;
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

class Album {
  final int countyID;
  final String countyName;

  Album({this.countyID, this.countyName});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      countyID: json['countyID'],
      countyName: json['countyName'],
    );
  }
}

class Country {
  final int id;
  final String name;

  Country({this.id, this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Aggregator extends StatefulWidget {
  @override
  _AggregatorState createState() => _AggregatorState();
}

class _AggregatorState extends State<Aggregator> {
  Future<List<Album>> futureAlbum;
  Future<List<Country>> futureCountry;
  Future<Message> _futureMessage;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<DropdownMenuItem<County>> list;
  Future<List<County>> fCountyList;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _organizationCodeController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _passwordConfirmController = new TextEditingController();
  TextEditingController _firstnameController = new TextEditingController();
  TextEditingController _lastnameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _countryController = new TextEditingController();
  String _email;
  String _password;
  String _confirmpassword;
  String _firstName;
  String _lastName;
  String _phone;
  String _county;
  String _organizationcode;
  bool _obsecure = false;

  Album dropdownValue;
  Album _currentUser;
  int _showbutton = 1;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    //futureCountry = fetchCountries();

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

    TextInputType inputType = hint == 'PHONE' ? TextInputType.number : TextInputType.text;
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        keyboardType: inputType,
        controller: controller,
        obscureText: obsecure,
        style: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 14, letterSpacing: 1.0),
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            hintText: hint,
            labelText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.grey[200],
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.grey[200],
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

  //input widget
  Widget _passwordinput(
      Icon icon, String hint, TextEditingController controller, bool obsecure) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: controller,
        obscureText: obsecure,
        maxLength: 4,
        style: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 14, letterSpacing: 1.0),
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            hintText: hint,
            labelText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.grey[200],
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.grey[200],
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

  void _registerUser() {
    _email = _emailController.text;
    _firstName = _firstnameController.text;
    _lastName = _lastnameController.text;
    _phone = _phoneController.text;
    _county = _countryController.text;
    _password = _passwordController.text;
    _confirmpassword = _passwordConfirmController.text;
    _organizationcode = _organizationCodeController.text;


    if(_password != _confirmpassword ){
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('The passwords do not match. Please reenter')));

    }else{
      setState(() {
        _showbutton = 0;
        _futureMessage = createAggregator(
            _firstName, _lastName, _email, _phone, _county, _password, _organizationcode).then((value){
              Message message = value;
              if(statusCode == 201){
                _scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text(message.message)));
                setState(() {
                  _showbutton = 1;
                });
                Navigator.popAndPushNamed(context, '/otp', arguments: {'phoneNumber': _phone});
              }else{
                _scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text(message.message)));
              }
              return;
        });
      });

    }
    
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

  Future<List<County>> _regetCountiesList() async {
    List<County> result = await _getCountiesList().then((value) {
      print('vals$value');
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('REGISTER AGGREGATOR',
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
          child:  Container(
                  child: ListView(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 20,
                              top: 50,
                            ),
                            child: _input(Icon(Icons.account_circle),
                                "FIRST NAME", _firstnameController, false),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 20,
                            ),
                            child: _input(Icon(Icons.account_circle),
                                "LAST NAME", _lastnameController, false),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 20, right: 20),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.0,
                                        style: BorderStyle.solid,
                                        color: Colors.grey[200]),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                /*child: DropdownButton<County>(
                          dropdownColor: Colors.white,
                          value: dropdownValue,
                          hint: Text('Select County'),
                          icon: Padding(
                            padding: const EdgeInsets.fromLTRB(0,0,8,0),
                            child: Icon(
                              Icons.arrow_drop_down_circle,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          isExpanded: true,
                          iconSize: 30,
                          elevation: 16,
                          underline: Container(
                            height: 0,
                            color: Theme.of(context).primaryColor,
                          ),
                          onChanged: (County newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: list,
                          /*items: _dropdownValues
                            .map((value) => DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                ))
                            .toList(),*/
                        ),

                      ),*/

                                child: FutureBuilder<List<Album>>(
                                    future: futureAlbum,
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                          return Center(
                                              child:
                                              CircularProgressIndicator());
                                        case ConnectionState.active:
                                        case ConnectionState.waiting:
                                          return Center(
                                              child:
                                              CircularProgressIndicator());
                                        case ConnectionState.done:
                                          print('hasdata${snapshot.hasData}');

                                          return DropdownButtonFormField(
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                                floatingLabelBehavior:
                                                FloatingLabelBehavior
                                                    .auto,
                                                hintStyle: TextStyle(
                                                    fontWeight:
                                                    FontWeight.normal,
                                                    fontSize: 16),
                                                hintText: 'SELECT COUNTY',
                                                //labelText: 'COUNTY',
                                                enabledBorder:
                                                InputBorder.none,
                                                icon: Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(20, 0, 0, 0),
                                                  child: Icon(
                                                    Icons.language,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                )),
                                            //, color: Colors.white10
                                            value: dropdownValue,
                                            //hint: Text('SELECT COUNTY'),
                                            icon: Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(
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
                                                .map<DropdownMenuItem<Album>>(
                                                    (Album county) {
                                                  return DropdownMenuItem<Album>(
                                                    value: county,
                                                    child: Text(county.countyName,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          //color: Color.fromRGBO(58, 66, 46, .9)
                                                        )),
                                                  );
                                                }).toList(),
                                            onChanged: (Album newValue) {
                                              setState(() =>
                                              dropdownValue = newValue);
                                              // selectedCountry = newValue;
                                              print(newValue.countyID);
                                              print(newValue.countyName);
                                            },
                                          );

                                        default:
                                          return Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3.0,
                                            ),
                                          );
                                      }
                                    })),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 20,
                            ),
                            child: _input(Icon(Icons.email), "EMAIL",
                                _emailController, false),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: _input(Icon(Icons.business), "ORGANIZATION CODE",
                                _organizationCodeController, false),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: _input(Icon(Icons.phone), "PHONE",
                                _phoneController, false),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: _passwordinput(Icon(Icons.lock_outline), "PASSWORD(4 digit number)",
                                _passwordController, true),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: _passwordinput(Icon(Icons.lock_outline), "CONFIRM PASSWORD",
                                _passwordConfirmController, true),
                          ),

                          Padding(
                            padding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: (_showbutton == 1) ?
                            Container(
                              child: _button("REGISTER", Colors.white, primary,
                                  primary, Colors.white, _registerUser),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                            ): Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3.0,
                                ),
                              ))
                          ),
                          SizedBox(
                            height: 50,
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
