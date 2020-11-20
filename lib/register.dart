import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _firstnameController = new TextEditingController();
  TextEditingController _lastnameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  String _email;
  String _password;
  String _firstName;
  String _lastName;
  String _phone;
  String _county;
  bool _obsecure = false;

  String dropdownValue = 'One';
  //input widget
  Widget _input(Icon icon, String hint, TextEditingController controller,
      bool obsecure) {
    int maxlength = 30;
    TextInputType textInputType = TextInputType.text;
    if(hint.compareTo("PHONE") == 0){
      maxlength = 13;
      textInputType = TextInputType.number;
    }else if(hint.compareTo("PIN") == 0){
      maxlength = 4;
      textInputType = TextInputType.number;
    }

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        keyboardType: textInputType,
        //maxLength: maxlength,
        controller: controller,
        obscureText: obsecure,
        style: TextStyle(
          fontSize: 12,
          letterSpacing: 1.0
        ),
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
    _email = _emailController.text;
    _password = _passwordController.text;
    _firstName = _firstnameController.text;
    _lastName = _lastnameController.text;
    _phone = _phoneController.text;

    _emailController.clear();
    _passwordController.clear();
    _firstnameController.clear();
    _lastnameController.clear();
    _phoneController.clear();
  }


  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text('REGISTER AGGREGATOR',
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
                      padding: EdgeInsets.only(
                          bottom: 20
                      ),
                      child: _input(Icon(Icons.phone), "PHONE",
                          _phoneController, false),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 20
                      ),
                      child: _input(Icon(Icons.lock), "PIN",
                          _passwordController, true),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
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
    );;
  }
}
