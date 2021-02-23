import 'package:AgriView/pages/elements/dialogs.dart';
import 'package:flutter/material.dart';

import '../../core/api/payment_provider.dart';
import 'deactivate.dart';
import 'topup.dart';

class WalletDashboard extends StatelessWidget {
  final String mobile;
  final _paymentProvider = PaymentProvider();
  WalletDashboard({
    Key key,
    this.mobile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/WalletLogin',
                  (route) => false,
                )),
      ),
      body: FutureBuilder(
        future: _paymentProvider.getWalletBalance(mobile),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data.right;
            print(data);
            return Container(
              margin: const EdgeInsets.only(top: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 10,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width / 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Mobile Number",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("+$mobile",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Actual Balance"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Kes ${data['actualBalance']}"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Available Balance",
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Kes ${data['availableBalance']}"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: MediaQuery.of(context).size.width / 3,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (_) => buildTopUpAlert()),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.green[100],
                                  child: Icon(
                                    Icons.account_balance_wallet,
                                    color: Theme.of(context).accentColor,
                                    size: 40,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Top Up",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.green[100],
                                child: Icon(
                                  Icons.account_balance_wallet,
                                  color: Theme.of(context).accentColor,
                                  size: 40,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Withdraw",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width / 6,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              Icon(Icons.refresh),
                              SizedBox(width: 20),
                              Text(
                                'Transaction History',
                              ),
                            ],
                          )),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            Future.delayed(
                Duration(milliseconds: 1),
                () => Dialogs.messageDialog(
                    context, true, snapshot.error.toString()));
            return Container();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  AlertDialog buildTopUpAlert() {
    return AlertDialog(
        title: Text("TOP UP WALLET",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            )),
        content: TopupWalletContent());
  }

  AlertDialog buildDeactivateAlert(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      contentPadding: EdgeInsets.all(20.0),
      backgroundColor: Theme.of(context).canvasColor,
      title: Container(
        alignment: Alignment.center,
        child: Text(
          "Warning!!",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      content: DeactivateWalletContent(),
    );
  }
}
