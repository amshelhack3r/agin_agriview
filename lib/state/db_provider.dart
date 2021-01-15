import 'package:flutter/material.dart';

import '../models/county.dart';
import '../models/cultivation_mode.dart';
import '../models/unit_type.dart';

class DatabaseProvider with ChangeNotifier {
  List<County> _county;
  List<CultivationMode> _mode;
  List<UnitType> _types;

  get county => _county;
  get modes => _mode;
  get unitType => _types;

  set county(List<County> county) {
    _county = county;
    notifyListeners();
  }

  set modes(List<CultivationMode> mode) {
    _mode = mode;
    notifyListeners();
  }

  set unitType(List<UnitType> types) {
    _types = types;
    notifyListeners();
  }
}
