import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'aggregator.dart';
import 'allproducelist.dart';
import 'api/api_provider.dart';
import 'blocs/BlocProvider.dart';
import 'dashboard.dart';
import 'farm.dart';
import 'farmer.dart';
import 'farmergroup.dart';
import 'farmerlist.dart';
import 'farmproduce.dart';
import 'farmslist.dart';
import 'models/message.dart';
import 'otp.dart';
import 'pages/farmdetail.dart';
import 'pages/farmerdetail.dart';
import 'pages/producedetail.dart';
import 'placetomarket.dart';
import 'producelist.dart';

void main() {
  runApp(MyApp());
}

int statusCode;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agin Farmer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          hintColor: new Color(0xff0ad7cb),
          primaryColor: new Color(0xff12a89f),
          primaryColorDark: Color(0xff1d8a84),
          primaryColorLight: Color(0xff0ad7cb),
          fontFamily: "Montserrat",
          canvasColor: Colors.white),
      home: Login(),
      routes: {
        '/register': (context) => Aggregator(),
        '/farmerlist': (context) => FarmerList(""),
        '/producelist': (context) => ProduceList(),
        '/allproducelist': (context) => AllProduceList(),
        '/farmslist': (context) => FarmsList(),
        '/newproduce': (context) => FarmProduce(),
        '/newfarmer': (context) => Farmer(),
        '/newfarmergroup': (context) => Farmergroup(),
        '/newfarm': (context) => Farm(),
        '/home': (context) => Dashboard(),
        '/detailfarmer': (context) => FarmerDetail(),
        '/detailfarm': (context) => FarmDetail(),
        '/detailproduce': (context) => ProduceDetail(),
        '/placemarket': (context) => PlaceToMarket(),
        '/otp': (context) => Otp(),
      },
    );
  }
}

class Login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<Login> {
  ApiProvider _apiProvider;
  Future<Message> _futureMessage;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  String _displayName;
  bool _obsecure = false;
  int _showbutton = 1;

  @override
  void initState() {
    super.initState();
    _apiProvider = ApiProvider();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;

    return Scaffold(
      key: _scaffoldKey,
      body: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white),
        child: ClipRRect(
          /* borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0)),*/
          child: Container(
            child: ListView(
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[],
                  ),
                  height: 50,
                  width: 50,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              child: Center(
                                  child: Image.asset(
                                      'assets/images/agriview_logo.jpg')),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20, top: 50),
                        child: _input(Icon(Icons.phone), "PHONE",
                            _emailController, false),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 0),
                        child: _input(
                            Icon(Icons.lock), "PIN", _passwordController, true),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgotpassword');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Forgot Password',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  letterSpacing: 0.0,
                                  fontSize: 15.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          child: _button("LOGIN", Colors.white, primary,
                              primary, Colors.white, _loginUser),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Not yet Registered? Click Here',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  letterSpacing: 0.0,
                                  fontSize: 15.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
        ),
      ),
    );
    ;
  }

  //input widget
  Widget _input(
      Icon icon, String hint, TextEditingController controller, bool obsecure) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        //maxLength: obsecure ? 4 : 13,
        keyboardType: TextInputType.number,
        //maxLengthEnforced: true,
        controller: controller,
        obscureText: obsecure,
        style: TextStyle(fontSize: 16, letterSpacing: 1.0),
        decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
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
    return (_showbutton == 1)
        ? RaisedButton(
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
          )
        : Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
              ),
            ));
  }

  void _loginUser() async {
    _email = _emailController.text;
    _password = _passwordController.text;
    var aggregatorLoginObject =
        await _apiProvider.loginAggregator(_email, _password);

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return BlocProvider<IncrementBloc>(
        bloc: IncrementBloc(),
        child: new Dashboard(
            aggregatorAginID: aggregatorLoginObject.youthAGINID,
            firstName: aggregatorLoginObject.firstName,
            lastName: aggregatorLoginObject.lastName),
      );
    }));
  }
}
