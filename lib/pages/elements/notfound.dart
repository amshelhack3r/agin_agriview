import 'package:flutter/material.dart';

class NotFound {

  Widget pageMessage(BuildContext context, IconData icon, String message){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Icon(
            icon,
            size: 50,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Center(
          child: Text(
            message,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }


}
