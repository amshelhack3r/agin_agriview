import 'package:flutter/material.dart';

import '../models/county.dart';
import '../models/cultivation_mode.dart';
import '../models/market_listings_meta.dart';
import '../models/produce_status.dart';
import '../models/unit_type.dart';

class DatabaseProvider with ChangeNotifier {
  List<County> _county;
  List<CultivationMode> _mode;
  List<UnitType> _types;
  List<Grade> _gradeList;
  List<ProduceStatus> _produceStatus;

  List<County> get county => _county;
  List<CultivationMode> get modes => _mode;
  List<UnitType> get unitType => _types;
  List<Grade> get grades => _gradeList;
  List<ProduceStatus> get productStatus => _produceStatus;

  set setCounty(List<County> county) {
    _county = county;
    notifyListeners();
  }

  set setModes(List<CultivationMode> mode) {
    _mode = mode;
    notifyListeners();
  }

  set setUnitType(List<UnitType> types) {
    _types = types;
    notifyListeners();
  }

  set setGrade(List<Grade> grades) {
    _gradeList = grades;
    notifyListeners();
  }

  set setProductStatus(List<ProduceStatus> statuses) {
    _produceStatus = statuses;
    notifyListeners();
  }
}
