import 'package:flutter/material.dart';

class SplashWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: SizedBox(
            width: 200,
            child: Image.asset(
              'assets/images/agriview_logo.jpg',
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
    ));
  }

  Future<bool> init() async {
    return Future.delayed(Duration(seconds: 5), () => true);
  }
}
