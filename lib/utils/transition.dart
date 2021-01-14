import 'package:flutter/material.dart';

PageRouteBuilder fadeAnimation(Widget secondScreen) {
  return PageRouteBuilder(
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondAnimation, Widget child) {
        animation =
            CurvedAnimation(parent: animation, curve: Curves.easeInToLinear);
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondAnimation) =>
          secondScreen);
}

PageRouteBuilder slideAnimation(Widget secondScreen) {
  return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondAnimation, Widget child) {
        return SlideTransition(
          child: child,
          position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
              .animate(animation),
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondAnimation) =>
          secondScreen);
}
