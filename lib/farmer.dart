import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:AgriView/models/County.dart';
import 'package:AgriView/utils/constants.dart';


int statusCode;
Future <List<Album>> fetchAlbum() async {
  final response =
  await http.get(Uri.parse('${serverURL}county/list'),
        headers: <String, String>{
        'X-AGIN-API-Key-Token': APIKEY,
        },);

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

Future<Message> createFarmer(String firstName,String lastName,String email,String phone,String county,String accountManagerAginID) async {

  final http.Response response = await http.post(
    Uri.parse('${serverURL}aggregator/register/farmer'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'X-AGIN-API-Key-Token': APIKEY,
    },
    body: jsonEncode(<String, String>{
      'FirstName' : firstName,
      'LastName' : lastName,
      'PhoneNumber' : phone,
      'EmailAddress' : email,
      'AccountManagerAginID' : accountManagerAginID,
      'CountyID' : county
    }),
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

class Farmer extends StatefulWidget {
  @override
  _FarmerState createState() => _FarmerState();
}

class _FarmerState extends State<Farmer> {
  Future<List<Album>> futureAlbum;
  Future<Message> _futureMessage;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Map data = {};
  List<DropdownMenuItem<County>> list;
  Future<List<County>> fCountyList;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _firstnameController = new TextEditingController();
  TextEditingController _lastnameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _countryController = new TextEditingController();
  String _email;
  String _password;
  String _firstName;
  String _lastName;
  String _phone;
  String _county;
  String _aggregatorAginID;
  bool _obsecure = false;

  Album dropdownValue;
  Album _currentUser;
  int _showbutton = 1;


  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();

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
  Widget _input(Icon icon, String hint, TextEditingController controller,
      bool obsecure) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
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
            fontWeight: FontWeight.bold, color: textColor, fontSize: 12),
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
    _county = dropdownValue.countyID.toString();

    setState(() {
      _showbutton = 0;
      _futureMessage = createFarmer(_firstName,_lastName,_email,_phone,_county,_aggregatorAginID).then((value){
        Message message = value;
        if(statusCode == 201){
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text(message.message)));
          setState(() {
            _showbutton = 1;
            _firstnameController.text = "";
            _lastnameController.text = "";
            _emailController.text = "";
            _phoneController.text = "";
          });
          Navigator.pop(context);
        }else{
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text(message.message)));
        }
        return;
      });
    });


    /*_emailController.clear();
    _firstnameController.clear();
    _lastnameController.clear();
    _phoneController.clear();
    _countryController.clear();*/
  }

  List<County> parseCounties(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    List<County> lc = parsed.map<County>((json) =>County.fromJson(json)).toList();
    print('parsed${parsed} ${lc.length}' );
    return lc;
  }

  Future<List<County>> _getCountiesList() async{
      HttpClient client = new HttpClient();
      List<County> conList;
      await client.getUrl(Uri.parse('${serverURL}county/list'))
          .then((HttpClientRequest request) {
        request.headers.add("X-AGIN-API-Key-Token", APIKEY);
        return request.close();
      })
          .then((HttpClientResponse response) {
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

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('REGISTER FARMER',
        style : TextStyle(
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
          child: (_futureMessage == null) ? Container(
            child: ListView(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 20,
                        top: 20,
                      ),
                      child: _input(Icon(Icons.account_circle),
                          "FIRST NAME", _firstnameController, false),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: _input(Icon(Icons.account_circle), "LAST NAME",
                          _lastnameController, false),
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
                      child: _input(Icon(Icons.phone), "PHONE",
                          _phoneController, false),
                    ),
                    FutureBuilder<List<Album>>(
                    future: futureAlbum,
                    builder: (context, snapshot) {
                      switch(snapshot.connectionState){
                        case ConnectionState.none:
                          return CircularProgressIndicator();
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return CircularProgressIndicator();
                        case ConnectionState.done:
                          print('hasdata${snapshot.hasData}');
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
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
                                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                                      hintStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                                      hintText: 'SELECT COUNTY',
                                      //labelText: 'COUNTY',
                                      enabledBorder: InputBorder.none,
                                      icon: Padding(
                                        padding: const EdgeInsets.fromLTRB(20,0,0,0),
                                        child: Icon(
                                          Icons.language,
                                          color: Theme.of(context).primaryColor,
                                        ),

                                      )

                                  ),
                                  value: dropdownValue,
                                  //hint: Text('SELECT COUNTY'),
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
                                  items: snapshot.data.map<DropdownMenuItem<Album>>((
                                      Album county) {
                                    return DropdownMenuItem<Album>(
                                        value: county,
                                        child: Text(county.countyName,
                                        style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              letterSpacing: 1.0,
                                               backgroundColor: Colors.white10

                                          ),
                                        )
                                    );
                                  }).toList(),
                                  onChanged: (Album newValue) {
                                    setState(() => dropdownValue = newValue);
                                    // selectedCountry = newValue;
                                    print(newValue.countyID);
                                    print(newValue.countyName);
                                  },
                                ),
                              ),
                            );

                        default:
                          return CircularProgressIndicator();
                      }
                    }),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
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
                          )
                      )
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
          :
          Container(
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
    );;
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
