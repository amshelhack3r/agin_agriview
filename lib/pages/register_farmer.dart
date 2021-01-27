import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../core/repository/api_repository.dart';
import '../models/county.dart';
import '../state/db_provider.dart';
import '../state/user_provider.dart';
import 'elements/dialogs.dart';
import 'elements/rounded_container.dart';

class RegisterFarmerPage extends StatefulWidget {
  RegisterFarmerPage({Key key}) : super(key: key);

  @override
  _RegisterFarmerPageState createState() => _RegisterFarmerPageState();
}

class _RegisterFarmerPageState extends State<RegisterFarmerPage> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  int selectedValue = 1;
  bool isValid = true;
  String firstNameError;
  String lastNameError;
  String mobileNameError;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    List<County> countyList = context.watch<DatabaseProvider>().county;
    return Scaffold(
      appBar: AppBar(
        title: Text("REGISTER FARMER"),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: Stack(children: [
            RoundedContainer(),
            Positioned(
              top: MediaQuery.of(context).size.height / 8,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Material(
                  shadowColor: Colors.white,
                  elevation: 4,
                  borderRadius: BorderRadius.circular(40),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: firstName,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  errorText: isValid ? null : firstNameError,
                                  hintText: "First Name",
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: lastName,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  errorText: isValid ? null : lastNameError,
                                  hintText: "Last Name",
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "Email Address(optional)",
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: mobile,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  errorText: isValid ? null : mobileNameError,
                                  hintText: "Phone Number",
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: DropdownButton(
                                  value: selectedValue,
                                  onChanged: (val) {
                                    setState(() {
                                      selectedValue = val;
                                    });
                                  },
                                  hint: Text("County"),
                                  items: [
                                    ...countyList
                                        .map((county) => DropdownMenuItem(
                                              child: Text(county.countyName),
                                              value: county.countyID,
                                            ))
                                        .toList()
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              isLoading
                                  ? RaisedButton(
                                      color: Colors.grey,
                                      elevation: 10,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 80, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      onPressed: () => null,
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                    )
                                  : RaisedButton(
                                      color: Theme.of(context).primaryColor,
                                      textColor: Colors.white,
                                      elevation: 10,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 80, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      onPressed: () => _registerFarmer(),
                                      child: Text(
                                        'Register',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  _registerFarmer() async {
    setState(() {
      isLoading = true;
    });
    var emailVal = (email.text.isEmpty) ? "" : email.text;
    var aginId = context.read<UserProvider>().aginId;
    if (firstName.text.isEmpty) {
      setState(() {
        isValid = false;
        firstNameError = "This input cannot be empty";
        isLoading = false;
      });
      return;
    }
    if (lastName.text.isEmpty) {
      setState(() {
        isValid = false;
        isLoading = false;
        lastNameError = "This input cannot be empty";
      });
      return;
    }
    if (mobile.text.isEmpty) {
      setState(() {
        isValid = false;
        isLoading = false;
        mobileNameError = "This input cannot be empty";
      });
      return;
    }

    Map params = {
      "phoneNumber": mobile.text,
      "emailAddress": emailVal,
      "firstName": firstName.text,
      "lastName": lastName.text,
      "countyID": "$selectedValue",
      "producerTypeID": 0,
      "accountManagerAginID": aginId,
    };

    try {
      if (await GetIt.I.get<ApiRepository>().registerFarmer(params)) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushNamed(context, '/HomePage', arguments: 2);
      }
    } catch (e) {
      Dialogs.messageDialog(context, true, e.toString());
    }
  }
}
