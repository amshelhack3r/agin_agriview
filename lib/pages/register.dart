import 'package:AgriView/state/db_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../core/repository/api_repository.dart';
import '../injection.dart';
import '../models/county.dart';
import '../utils/AppUtil.dart';
import '../utils/constants.dart';
import 'elements/dialogs.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool isFirst = true;
  bool isValid = true;
  bool isLoading = false;
  var _dateController = TextEditingController();
  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _mobileController = TextEditingController();
  var _passwordController = TextEditingController();
  var _emailController = TextEditingController();
  County _selectedCounty;

  String _dateError,
      _firstNameError,
      _lastNameError,
      _mobileError,
      _passwordError,
      _emailError;
  List<County> _countyList;

  @override
  void initState() {
    super.initState();
    _countyList = context.read<DatabaseProvider>().county;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: isFirst ? _firstForm() : _secondForm(),
    );
  }

  _firstForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _firstNameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            errorText: (_firstNameError != null) ? _firstNameError : null,
            hintText: "First Name",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _lastNameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            errorText: (_lastNameError != null) ? _lastNameError : null,
            hintText: "Last Name",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            errorText: (_mobileError != null) ? _mobileError : null,
            hintText: "Phone Number",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          // enabled: false,
          controller: _dateController,
          decoration: InputDecoration(
            errorText: (_dateError != null) ? _dateError : null,
            labelText: "Date of Birth",
          ),
          onTap: () {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime(1950, 1, 1),
                maxTime: DateTime(2003, 1, 1), onChanged: (date) {
              print('change $date');
            }, onConfirm: (date) {
              print('confirm $date');
              final DateFormat formatter = DateFormat('yyyy-MM-dd');
              final String formatted = formatter.format(date);
              _dateController.text = formatted;
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.grey),
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        RaisedButton.icon(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          elevation: 10,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: () {
            setState(() {
              isFirst = false;
            });
          },
          icon: Icon(Icons.chevron_right),
          label: Text(
            'Next',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

  _secondForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _passwordController,
          obscureText: true,
          maxLength: 4,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            errorText: (_passwordError != null) ? _passwordError : null,
            hintText: "Password",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: DropdownButton<County>(
            hint: Text("County"),
            value: _selectedCounty,
            focusColor: Colors.red,
            onChanged: (County newValue) {
              setState(() {
                _selectedCounty = newValue;
              });
            },
            items: _countyList
                .map(
                  (County fName) => DropdownMenuItem<County>(
                    child: Text(fName.countyName),
                    value: fName,
                  ),
                )
                .toList(),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            errorText: (_emailError != null) ? _emailError : null,
            hintText: "Email Address",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.grey),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor),
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RaisedButton.icon(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              elevation: 10,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                setState(() {
                  isFirst = true;
                });
              },
              icon: Icon(Icons.chevron_left),
              label: Text(
                '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
            isLoading
                ? RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    elevation: 10,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: () {},
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
                : RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    elevation: 10,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: () => _register(),
                    child: Text(
                      'Sign Up',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  _register() {
    var mobile;
    if (_firstNameController.text.isEmpty) {
      setState(() {
        _firstNameError = "First name is required";
        isValid = false;
      });
      showError(_firstNameError);
      return;
    }
    if (_lastNameController.text.isEmpty) {
      setState(() {
        _lastNameError = "Last name is required";
        isValid = false;
      });
      showError(_lastNameError);
      return;
    }
    if (_mobileController.text.isEmpty) {
      setState(() {
        _mobileError = "Phone number is required";
        isValid = false;
      });
      showError(_mobileError);
      return;
    }
    if (_dateController.text.isEmpty) {
      setState(() {
        _dateError = "Date is required";
        isValid = false;
      });
      showError(_dateError);
      return;
    }
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = "Password is required";
        isValid = false;
      });
      showError(_passwordError);
      return;
    }

    if (_passwordController.text.length < 4) {
      setState(() {
        _passwordError = "Password should be atleast 4characters";
        isValid = false;
      });
      showError(_passwordError);
      return;
    }

    if (_selectedCounty == null) {
      setState(() {
        isValid = false;
      });
      showError("Please select a county");
      return;
    }

    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = "Email is required";
        isValid = false;
      });
      showError(_emailError);
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      mobile = AppUtil.formatMobileNumber(_mobileController.text);
      _mobileController.text = mobile;
    } on FormatException {
      setState(() {
        isLoading = false;
        isValid = false;
      });
      return;
    }

    var params = {
      "status": 0,
      "password": _passwordController.text,
      "countyID": _selectedCounty.countyID,
      "phoneNumber": mobile,
      "emailAddress": _emailController.text,
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "countryID": 1,
      "organizationCode": ORGANIZATION_ID,
      "dateBirth": _dateController.text
    };

    var repo = getIt.get<ApiRepository>();
    var formattedMobile = AppUtil.formatMobileNumber(_mobileController.text);
    repo
        .createUser(params)
        .then((value) => Navigator.pushNamed(context, "/VerifyPage",
            arguments: formattedMobile))
        .catchError((err) {
      if (err is DioError) {
        Dialogs.messageDialog(context, true, err.message);
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  showError(String msg) {
    showToast(msg,
        position: ToastPosition.bottom,
        duration: Duration(seconds: 2),
        textStyle: TextStyle(color: Colors.white, fontSize: 14),
        backgroundColor: Theme.of(context).primaryColor,
        textPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10));
  }
}
