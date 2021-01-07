import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 10,
          ),
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "First Name",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "Last Name",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "County",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email Address",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Organization code",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Phone Number",
            ),
          ),
          SizedBox(
            height: 10,
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
            height: 10,
          ),
          TextField(
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Confirm Password",
            ),
          ),
          SizedBox(
            height: 15,
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
              'Sign Up',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
