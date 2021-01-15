import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: isFirst ? _firstForm() : _secondForm(),
    );
  }

  _firstForm() {
    return Column(
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
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Organization code",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.grey),
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        RaisedButton.icon(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          elevation: 10,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: () {
            setState(() {
              isFirst = false;
            });
          },
          icon: Icon(Icons.chevron_right),
          label: Text(
            'Next',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

  _secondForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 10,
        ),
        TextField(
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Password",
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.grey),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor),
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RaisedButton.icon(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              elevation: 10,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                setState(() {
                  isFirst = true;
                });
              },
              icon: Icon(Icons.chevron_left),
              label: Text(
                '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              elevation: 10,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () => _register(),
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _register() {}
}
