import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../core/api/payment_provider.dart';
import '../../state/user_provider.dart';

class DeactivateWalletContent extends StatefulWidget {
  DeactivateWalletContent({Key key}) : super(key: key);

  @override
  _DeactivateWalletContentState createState() =>
      _DeactivateWalletContentState();
}

class _DeactivateWalletContentState extends State<DeactivateWalletContent> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return isLoading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("DEACTIVATING...")
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Once deactivated, you wont be able to pay using wallet",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              _buildDeactivateBtn(width, height, context),
            ],
          );
  }

  _buildDeactivateBtn(var width, var height, var context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            isLoading = true;
          });
          var _payment = PaymentProvider();
          _payment
              .deactivateWallet(context.watch<UserProvider>().mobile)
              .then((value) {
            Navigator.pop(context, true);
          }).catchError((error) {
            print(error.toString());
          });
        },
        child: Container(
          width: double.infinity,
          height: 0.05 * height,
          decoration: BoxDecoration(color: appColor, boxShadow: [
            BoxShadow(
              blurRadius: 3.0,
              color: appColor.withOpacity(0.2),
              spreadRadius: 2.0,
              offset: Offset(0.0, 2.0),
            )
          ]),
          child: Center(
            child: Text(
              "DEACTIVATE",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
