import 'package:AgriView/core/repository/api_repository.dart';
import 'package:AgriView/pages/elements/dialogs.dart';
import 'package:AgriView/utils/AppUtil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import '../injection.dart';

class VerifyPage extends StatefulWidget {
  String mobile;
  VerifyPage({this.mobile});

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  TextEditingController _mobileController = TextEditingController();
  String _mobileError;
  bool isValid = true;
  bool isSending = false;
  bool isActivating = false;
  bool loaderIsShowing;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.mobile != null) {
      _mobileController.text = widget.mobile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("VERIFY USER"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/agriview_logo.jpg",
              width: 150,
              fit: BoxFit.cover,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: TextField(
                      controller: _mobileController,
                      decoration: InputDecoration(
                          errorText:
                              (_mobileError != null) ? _mobileError : null,
                          border: OutlineInputBorder(),
                          labelText: "MOBILE NUMBER"),
                    ),
                  ),
                ],
              ),
            ),
            isSending
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 5,
                      ),
                      Text("SENDING VERIFICATION")
                    ],
                  )
                : ElevatedButton.icon(
                    onPressed: () => _sendVerify(),
                    icon: Icon(Icons.send),
                    label: Text("Send Code")),
            SizedBox(
              height: 40,
            ),
            isActivating
                ? CircularProgressIndicator()
                : Container(
                    width: MediaQuery.of(context).size.width,
                    child: OTPTextField(
                      length: 5,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 20,
                      style: TextStyle(fontSize: 17),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.underline,
                      onCompleted: (pin) {
                        print("Completed: " + pin);
                        var repo = getIt<ApiRepository>();
                        var params = {
                          "verifyCode": pin,
                          "phoneNumber":
                              AppUtil.formatMobileNumber(_mobileController.text)
                        };
                        repo.activateUser(params).then((value) {
                          Dialogs.messageDialog(context, false,
                              "Successfully Activated \n Login");
                          Future.delayed(Duration(seconds: 4),
                              () => Navigator.pushNamed(context, '/AuthPage'));
                        }).catchError((err) {
                          if (err is DioError) {
                            Dialogs.messageDialog(context, true, err.message);
                          }
                        });
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _sendVerify() {
    if (_mobileController.text.isEmpty) {
      setState(() {
        isValid = false;
        _mobileError = "mobile number cannot be empty";
      });
      return;
    }
    setState(() {
      isSending = true;
    });
    var repo = getIt<ApiRepository>();
    repo
        .verifyUser(AppUtil.formatMobileNumber(_mobileController.text))
        .then((value) {
      showToast("Enter verification below");
    }).catchError((err) {
      if (err is DioError) {
        Dialogs.messageDialog(context, true, err.message);
      }
      setState(() {
        isSending = false;
      });
    });
  }
}
