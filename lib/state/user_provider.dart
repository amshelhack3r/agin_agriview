import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name;
  String _aginId;
  String _mobile;

  get fullname => _name;
  get aginId => _aginId;
  get mobile => _mobile;

  set defaultUser(Map<String, String> user) {
    _name = user['fullname'];
    _aginId = user['aginId'];
    _mobile = user['mobile'];
    notifyListeners();
  }
}
