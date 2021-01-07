import 'package:AgriView/pages/revamp/register.dart';
import 'package:flutter/material.dart';

import '../elements/rounded_container.dart';
import 'login.dart';

class Auth extends StatefulWidget {
  Auth({Key key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool isLogin = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              RoundedContainer(),
              Positioned(
                top: MediaQuery.of(context).size.height / 8,
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Material(
                    shadowColor: Colors.white,
                    elevation: 4,
                    borderRadius: BorderRadius.circular(40),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2.5,
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(25)),
                            height: 50,
                            alignment: Alignment.topCenter,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isLogin = true;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: isLogin
                                              ? Border.all(
                                                  width: 2.5,
                                                  color: Theme.of(context)
                                                      .primaryColor)
                                              : null,
                                          color: isLogin
                                              ? Theme.of(context).primaryColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Log In',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: isLogin
                                              ? Colors.white
                                              : Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isLogin = false;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: isLogin
                                              ? null
                                              : Border.all(
                                                  width: 2.5,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                          color: isLogin
                                              ? Colors.white
                                              : Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: isLogin
                                              ? Theme.of(context).primaryColor
                                              : Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          isLogin ? LoginForm() : RegisterForm(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/images/agriview_logo.jpg',
                  width: 200,
                  height: 100,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
