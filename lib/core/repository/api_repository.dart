import 'package:shared_preferences/shared_preferences.dart';

import '../../models/county.dart';
import '../../models/cultivation_mode.dart';
import '../../models/farm.dart';
import '../../models/farmer_info.dart';
import '../../models/login_object.dart';
import '../../models/product.dart';
import '../../models/unit_type.dart';
import '../../utils/constants.dart';
import '../api/api_provider.dart';
import 'repository.dart';

class ApiRepository extends Repository {
  @override
  String getType() => 'api';
  ApiProvider _apiProvider;
  ApiRepository() {
    _apiProvider = ApiProvider();
  }

  Future<AggregatorLoginObject> loginUser(Map params) async {
    var result = await _apiProvider.loginAggregator(params);

    if (result.isRight) {
      //save user to shared preferences
      var user = AggregatorLoginObject.fromMap(result.right);

      var preferences = await SharedPreferences.getInstance();
      preferences.setString(PREF_NAME, user.fullName);
      preferences.setString(PREF_AGINID, user.youthAGINID);
      preferences.setString(PREF_MOBILE, user.phoneNumber);
      preferences.setBool(PREF_HAS_LOGGED_IN, true);

      return user;
    } else {
      throw result.left;
    }
    return (result.isRight)
        ? AggregatorLoginObject.fromMap(result.right)
        : throw result.left;
  }

  Future createUser(Map params) async {
    var result = await _apiProvider.createAggregator(params);

    return (result.isRight) ? "User Created Successfully" : result.left.message;
  }

  Future verifyUser(Map params) async {
    var result = await _apiProvider.verifyAccount(
        params["phoneNumber"], params["verifyCode"]);

    return result;
  }

  Future<List<County>> fetchCounty() async {
    var result = await _apiProvider.fetchCounty();

    if (result.isRight) {
      return result.right.map((county) => County.fromMap(county)).toList();
    } else {
      throw result.left;
    }
  }

  Future<List<FarmerInfo>> fetchFarmers(String aginId) async {
    var result = await _apiProvider.fetchFarmers(aginId);
    if (result.isRight) {
      return result.right.map((farmer) => FarmerInfo.fromMap(farmer)).toList();
    } else {
      throw result.left;
    }
  }

  Future<bool> registerFarmer(Map params) async {
    var result = await _apiProvider.createFarmer(params);
    return (result == 201);
  }

  Future<List<CultivationMode>> fetchCultivationModes() async {
    var result = await _apiProvider.fetchCultivationModeOptions();

    if (result.isRight) {
      return result.right.map((mode) => CultivationMode.fromMap(mode)).toList();
    } else {
      throw result.left;
    }
  }

  Future<List<UnitType>> fetchUnitTypes() async {
    var result = await _apiProvider.fetchUnitTypeOptions();
    if (result.isRight) {
      return result.right
          .map((unitType) => UnitType.fromMap(unitType))
          .toList();
    } else {
      throw result.left;
    }
  }

  Future<List<Farm>> fetchFarm(String userAginID) async {
    var results = await _apiProvider.fetchFarms(userAginID);

    if (results.isRight) {
      return results.right.map((farm) => Farm.fromMap(farm)).toList();
    } else {
      throw results.left;
    }
  }

  Future<List<Product>> fetchProduce() async {
    var result = await _apiProvider.fetchProduce();

    if (result.isRight) {
      print(result.right);
      return result.right.map((product) => Product.fromMap(product)).toList();
    } else {
      throw result.left;
    }
  }
}
