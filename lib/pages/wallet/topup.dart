import '../../core/api/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../core/repository/api_repository.dart';
import '../../injection.dart';
import '../../state/user_provider.dart';
import '../elements/dialogs.dart';

class TopupWalletContent extends StatefulWidget {
  TopupWalletContent({Key key}) : super(key: key);

  @override
  _TopupWalletContentState createState() => _TopupWalletContentState();
}

class _TopupWalletContentState extends State<TopupWalletContent> {
  TextEditingController amount = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Processing Payment...")
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: amount,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.blue),
                decoration: InputDecoration(
                  hintText: "amount",
                  prefixIcon: Icon(
                    Icons.money,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                ),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "min amount is kes 10",
                  style: TextStyle(fontStyle: FontStyle.italic),
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
                  if (amount.text.isNotEmpty) {
                    if (int.parse(amount.text) >= 10) {
                      Map params = {
                        "mpesaAccountNumber":
                            context.watch<UserProvider>().mobile,
                        "phoneNumber": context.watch<UserProvider>(),
                        "amount": amount.text,
                      };
                      var _payment = PaymentProvider();
                      _payment.pushStkMpesa(params).then((value) {
                        print(value);
                        Navigator.pop(context, true);
                      }).catchError((error) {
                        print("error ${error.toString()}");
                      });
                    } else {
                      //value cannot be less than 10
                      Future.delayed(
                          Duration(seconds: 1),
                          () => Dialogs.messageDialog(
                              context, true, "Cannot top up less than kes 10"));
                    }
                  } else {
                    Navigator.pop(context, false);
                  }
                },
                child: Text("PAY", style: TextStyle(color: Colors.white)),
              )
            ],
          );
  }
}
