import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/county.dart';
import '../../models/cultivation_mode.dart';
import '../../models/farm.dart';
import '../../models/farmer_info.dart';
import '../../models/login_object.dart';
import '../../models/message.dart';
import '../../models/produce_status.dart';
import '../../models/product.dart';
import '../../models/unit_type.dart';
import '../../utils/constants.dart';
import '../../utils/gpx_util.dart';
import '../api/api_provider.dart';
import 'repository.dart';

class ApiRepository extends Repository {
  @override
  String getType() => 'api';

  ApiProvider api;
  ApiRepository({this.api});

  Future<AggregatorLoginObject> loginUser(Map params) async {
    var result = await api.loginAggregator(params);

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
  }

  Future createUser(Map params) async {
    var result = await api.createAggregator(params);

    return (result.isRight) ? "User Created Successfully" : result.left.message;
  }

  Future<List<County>> fetchCounty() async {
    var result = await api.fetchCounty();

    if (result.isRight) {
      return result.right.map((county) => County.fromMap(county)).toList();
    } else {
      throw result.left;
    }
  }

  Future<List<dynamic>> fetchLandProduce(String landAginID) async {
    var result = await api.fetchProduceByLandAgin(landAginID);
    return result.map((entry) => entry['productUuid']).toList();
  }

  Future<List<FarmerInfo>> fetchFarmers(String aginId) async {
    var result = await api.fetchFarmers(aginId);
    if (result.isRight) {
      return result.right.map((farmer) => FarmerInfo.fromMap(farmer)).toList();
    } else {
      throw result.left;
    }
  }

  Future<bool> registerFarmer(Map params) async {
    var result = await api.createFarmer(params);
    return (result == 201);
  }

  Future<List<CultivationMode>> fetchCultivationModes() async {
    var result = await api.fetchCultivationModeOptions();

    if (result.isRight) {
      return result.right.map((mode) => CultivationMode.fromMap(mode)).toList();
    } else {
      throw result.left;
    }
  }

  Future<List<UnitType>> fetchUnitTypes() async {
    var result = await api.fetchUnitTypeOptions();
    if (result.isRight) {
      return result.right
          .map((unitType) => UnitType.fromMap(unitType))
          .toList();
    } else {
      throw result.left;
    }
  }

  Future<List<Farm>> fetchFarm(String userAginID) async {
    var results = await api.fetchFarms(userAginID);

    if (results.isRight) {
      return results.right.map((farm) => Farm.fromMap(farm)).toList();
    } else {
      throw results.left;
    }
  }

  Future<List<Product>> fetchProduce() async {
    var result = await api.fetchProduce();

    if (result.isRight) {
      return result.right.map((product) => Product.fromMap(product)).toList();
    } else {
      throw result.left;
    }
  }

  Future<bool> addFarm(Map params) async {
    var results = await api.createFarm(params);
    return results;
  }

  Future<List<dynamic>> getProductListing(String productUUID) async {
    var result = await api.fetchProductListings(productUUID);

    if (result.isRight) {
      return result.right;
    } else {
      throw result.left;
    }
  }

  Future<String> uploadGpxData(Map data) async {
    var gpxUtil = GpxUtil(
        lat: data['lat'],
        lon: data['lon'],
        name: data['name'],
        desc: data['desc']);

    File file = await gpxUtil.writeToFile();

    var items = {
      "farmerAginId": data["farmerAginId"],
      "farmAginId": data["farmAginId"],
      "path": file.path,
      "fileName": data['name']
    };

    var result = await api.uploadGpxFile(items);

    if (result.isRight) {
      return result.right['message'];
    } else {
      Fimber.i(result.left.message);
      throw result.left;
    }
  }

  Future<Map<String, List<Object>>> getPlaceToMarketDetails() async {
    var result = await api.getPlaceToMarketDetails();

    if (result.isRight) {
      var data = result.right;
      Map<String, List> map = data[0];

      List<CultivationMode> modes = map['cultivationModes']
          .map((mode) => CultivationMode.fromMap(mode))
          .toList();

      List<ProduceStatus> produceStatus = map['produceStatuses']
          .map((status) => ProduceStatus.fromMap(status))
          .toList();

      List<UnitType> types =
          map['unitTypes'].map((type) => UnitType.fromMap(type)).toList();

      return {"cultivation": modes, "status": produceStatus, "type": types};
    } else {
      throw result.left;
    }
  }

  Future<Message> placeToMarket(FormData params) async {
    var result = await api.createPlacetoMarket(params);
    return result;
  }

  Future<bool> addProduce(Map params) async {
    var result = await api.createFarmProduce(params);

    if (result.isRight) {
      return true;
    } else {
      throw result.isLeft;
    }
  }
}
