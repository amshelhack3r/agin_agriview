import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 20,
          ),
          TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Phone Number",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            obscureText: true,
            maxLength: 4,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Password",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            elevation: 10,
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: () => Navigator.pushNamed(context, "/DashboardPage"),
            child: Text(
              'Log In',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Forgot Password?',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
