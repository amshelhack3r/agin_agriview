import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../core/api/payment_provider.dart';
import '../../state/user_provider.dart';
import '../elements/dialogs.dart';

class ActivateWalletContent extends StatefulWidget {
  ActivateWalletContent({Key key}) : super(key: key);

  @override
  _ActivateWalletContentState createState() => _ActivateWalletContentState();
}

class _ActivateWalletContentState extends State<ActivateWalletContent> {
  TextEditingController idNumber = TextEditingController();
  TextEditingController pin = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool obscureText = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Fimber.i(user.toString())
    return isLoading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Activating...")
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                readOnly: true,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.blue),
                decoration: InputDecoration(
                  hintText: context.watch<UserProvider>().mobile,
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                controller: pin,
                obscureText: obscureText,
                maxLength: 4,
                style: TextStyle(color: Colors.blue),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      }),
                  hintText: "4 digit pin",
                  hintStyle: TextStyle(
                    color: Colors.blue[500],
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                controller: idNumber,
                style: TextStyle(color: Colors.blue),
                decoration: InputDecoration(
                  hintText: "ID number",
                  hintStyle: TextStyle(
                    color: appColor,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                controller: amountController,
                style: TextStyle(color: Colors.blue),
                onEditingComplete: () {
                  if (int.parse(amountController.text) < 10) {
                    Dialogs.messageDialog(
                        context, true, "Value should be ksh10 or greater");
                  }
                },
                decoration: InputDecoration(
                  hintText: "amount",
                  hintStyle: TextStyle(
                    color: appColor,
                  ),
                  labelText: "Enter amount greater than 10",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                ),
              ),
              SizedBox(height: 20),
              RaisedButton(
                color: appColor,
                padding: EdgeInsets.all(10),
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  if (pin.text.isNotEmpty &&
                      idNumber.text.isNotEmpty &&
                      amountController.text.isNotEmpty) {
                    Map params = {
                      "mpesaAccountNumber":
                          context.watch<UserProvider>().mobile,
                      "accountName": context.watch<UserProvider>().mobile,
                      "nationalIDNumber": idNumber.text,
                      "pin": pin.text,
                      "activationAmount": int.parse(amountController.text),
                      "termsAcceptedStatusCode": "true",
                      "userAginID": context.watch<UserProvider>().aginId
                    };
                    var _payment = PaymentProvider();
                    _payment.activateWallet(params).then((value) {
                      print(value);
                      Navigator.pop(context, true);
                    }).catchError((error) {
                      print("error ${error.toString()}");
                    });
                  } else {
                    Navigator.pop(context, false);
                  }
                },
                child: Text("ACTIVATE", style: TextStyle(color: Colors.white)),
              )
            ],
          );
  }
}
