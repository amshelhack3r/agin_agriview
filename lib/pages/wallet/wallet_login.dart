import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../injection.dart';
import '../../state/user_provider.dart';
import '../../utils/constants.dart';
import '../elements/dialogs.dart';
import 'activate.dart';

class WalletLogin extends StatefulWidget {
  @override
  State<WalletLogin> createState() => _WalletLoginState();
}

class _WalletLoginState extends State<WalletLogin> {
  var pin = TextEditingController();
  var mobile = TextEditingController();

  @override
  void initState() {
    super.initState();
    mobile.text = context.watch<UserProvider>().mobile;
  }

  void setToken(String token) {
    AuthLink alink = AuthLink(getToken: () async => token);
    alink.concat(getIt<HttpLink>());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green[50],
        resizeToAvoidBottomInset: true,
        appBar: AppBar(),
        body: Mutation(
          options: MutationOptions(
              document: gql(
                  GRAPHQL_MUTATION), // this is the mutation string you just created
              // you can update the cache based on results
              update: (GraphQLDataProxy cache, QueryResult result) {
                return cache;
              },
              // or do something with the result.data on completion
              onCompleted: (dynamic resultData) {
                var accountNumber =
                    resultData['login']['account']['accountNumber'];
                setToken(resultData['login']['token']);
                print(resultData);
                print(getIt<HttpLink>());
                Navigator.pushNamedAndRemoveUntil(
                    context, '/WalletDashboard', (route) => true,
                    arguments: accountNumber);
              },
              onError: (OperationException e) {
                Future.delayed(Duration(seconds: 1),
                    () => Dialogs.messageDialog(context, true, e.toString()));
              }),
          builder: (
            RunMutation runMutation,
            QueryResult result,
          ) {
            if (result.isLoading) {
              return Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Authenticating')
                  ],
                ),
              );
            } else if (result.hasException) {
              Future.delayed(
                  Duration(milliseconds: 1),
                  () => Dialogs.messageDialog(context, true,
                      result.exception.graphqlErrors[0].message));

              return Center(
                  child: RaisedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Go Back"),
              ));
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "WALLET LOGIN",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: mobile,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: "254 7XX XXX XXX",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: pin,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.blue),
                            maxLength: 4,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              hintText: "4 digit pin",
                              hintStyle: TextStyle(
                                color: Colors.blue[500],
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RaisedButton(
                                    color: Theme.of(context).accentColor,
                                    onPressed: () => runMutation({
                                          "phoneNumber": context
                                              .watch<UserProvider>()
                                              .mobile,
                                          "password": pin.text
                                        }),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Text(
                                        "LOGIN",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    "Recover Pin?",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline),
                                  )),
                              GestureDetector(
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => buildRegisterAlert(),
                                    barrierDismissible: true),
                                child: Text(
                                  "Activate Wallet",
                                  style: TextStyle(color: Colors.blue[600]),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  AlertDialog buildRegisterAlert() {
    return AlertDialog(
        title: Text("ACTIVATE WALLET",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            )),
        content: ActivateWalletContent());
  }
}

// Container(
//   child: isLoading
//       ? Center(
//           child: Loader(),
//         )
//       : FutureBuilder(
//           // initialData: data,
//           future: getIt.get<Repository>().getWalletBalance(),
//           builder:
//               (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
//             if (snapshot.hasData) {
//               var currency = snapshot.data["accountCurrency"] as String;
//               if (currency.isEmpty) {
//                 return activateWalletState();
//               } else {
//                 return _walletBalanceState(snapshot.data);
//               }
//             } else if (snapshot.hasError) {
//               return Center(
//                   child: Text(
//                 snapshot.error.toString(),
//                 style: TextStyle(color: Colors.red),
//               ));
//             } else {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [Loader(), Text("LOADING WALLET INFO")],
//                 ),
//               );
//             }
//           },
//         ),
// ),
