import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum DialogAction { yes, abort }

class Dialogs {
  static Future<DialogAction> messageDialog(
      BuildContext context, bool isError, String body) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: isError
                ? Icon(
                    Icons.highlight_off,
                    color: Colors.red,
                    size: 50,
                  )
                : Icon(
                    Icons.check_circle_outline,
                    color: Colors.green[300],
                    size: 50,
                  ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "close",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  "assets/images/agriview_logo.jpg",
                  width: 80,
                )
              ],
            ),
          );
        });
    return (action != null) ? action : DialogAction.yes;
  }
}
