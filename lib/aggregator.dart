import 'dart:convert';
import 'dart:io';
import 'package:AgriView/dialog/dialogs.dart';
import 'package:AgriView/models/country.dart';
import 'package:AgriView/otp.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:AgriView/models/County.dart';
import 'package:AgriView/utils/constants.dart';

import 'api/api_provider.dart';
import 'models/album.dart';
import 'models/message.dart';

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
  TextEditingController _organizationCodeController =
      new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _passwordConfirmController =
      new TextEditingController();
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
  final _apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();

    futureAlbum = _apiProvider.fetchAlbum();
  }

  //input widget
  Widget _input(
      Icon icon, String hint, TextEditingController controller, bool obsecure) {
    TextInputType inputType =
        hint == 'PHONE' ? TextInputType.number : TextInputType.text;
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

    if (_password != _confirmpassword) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('The passwords do not match. Please reenter')));
    } else {
      setState(() {
        _showbutton = 0;
        _futureMessage = _apiProvider
            .createAggregator(_firstName, _lastName, _email, _phone, _county,
                _password, _organizationcode)
            .then((value) {
          if (value.responsecode == 201) {
            _scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text(value.message)));
            setState(() {
              _showbutton = 1;
            });
            Navigator.popAndPushNamed(context, '/otp',
                arguments: {'phoneNumber': _phone});
          } else {
            _scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text(value.message)));
          }
          return;
        });
      });
    }
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
            child: Container(
          child: ListView(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 20,
                      top: 50,
                    ),
                    child: _input(Icon(Icons.account_circle), "FIRST NAME",
                        _firstnameController, false),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: _input(Icon(Icons.account_circle), "LAST NAME",
                        _lastnameController, false),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 20, left: 20, right: 20),
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
                        child: FutureBuilder<List<Album>>(
                            future: futureAlbum,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return Center(
                                      child: CircularProgressIndicator());
                                case ConnectionState.active:
                                case ConnectionState.waiting:
                                  return Center(
                                      child: CircularProgressIndicator());
                                case ConnectionState.done:
                                  print('hasdata${snapshot.hasData}');

                                  return DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16),
                                        hintText: 'SELECT COUNTY',
                                        //labelText: 'COUNTY',
                                        enabledBorder: InputBorder.none,
                                        icon: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 0, 0),
                                          child: Icon(
                                            Icons.language,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )),
                                    //, color: Colors.white10
                                    value: dropdownValue,
                                    //hint: Text('SELECT COUNTY'),
                                    icon: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                      child: Icon(
                                        Icons.arrow_drop_down_circle,
                                        color: Theme.of(context).primaryColor,
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
                                      setState(() => dropdownValue = newValue);
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
                    child: _input(
                        Icon(Icons.email), "EMAIL", _emailController, false),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _input(Icon(Icons.business), "ORGANIZATION CODE",
                        _organizationCodeController, false),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _input(
                        Icon(Icons.phone), "PHONE", _phoneController, false),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _passwordinput(Icon(Icons.lock_outline),
                        "PASSWORD(4 digit number)", _passwordController, true),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _passwordinput(Icon(Icons.lock_outline),
                        "CONFIRM PASSWORD", _passwordConfirmController, true),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: (_showbutton == 1)
                          ? Container(
                              child: _button("REGISTER", Colors.white, primary,
                                  primary, Colors.white, _registerUser),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                            )
                          : Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3.0,
                                ),
                              ))),
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
        )),
      ),
    );
    ;
  }
}
