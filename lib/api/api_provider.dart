import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/AggregatorLoginObject.dart';
import '../models/County.dart';
import '../models/FarmerProduceInfo.dart';
import '../models/Product.dart';
import '../models/album.dart';
import '../models/country.dart';
import '../models/cultivation_mode.dart';
import '../models/farmer_info.dart';
import '../models/market_listing_info.dart';
import '../models/message.dart';
import '../models/produce_status.dart';
import '../models/statistic_info.dart';
import '../models/unit_type.dart';
import '../utils/constants.dart';

class ApiProvider {
  final client = http.Client();
  final headers = {"X-AGIN-API-Key-Token": APIKEY};
  final jsonHeaders = {
    "X-AGIN-API-Key-Token": APIKEY,
    "Content-Type": "application/json"
  };

  static buildUrl(String endpoint) => Uri.parse(BASEURL + endpoint);

  Future<List<Country>> fetchCountries() async {
    final response =
        await client.get(buildUrl(FETCH_COUNTRIES), headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Country> listCountries = items.map<Country>((json) {
        return Country.fromJson(json);
      }).toList();
      return listCountries;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<List<Album>> fetchAlbum() async {
    final response = await client.get(buildUrl(FETCH_ALBUM), headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Album> listAlbums = items.map<Album>((json) {
        return Album.fromJson(json);
      }).toList();
      return listAlbums;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Message> createAggregator(
      String firstName,
      String lastName,
      String email,
      String phone,
      String county,
      String password,
      String organizationCode) async {
    headers['Content-Type'] = 'application/json';
    final http.Response response = await client.post(
      buildUrl(REGISTER_AGGREGATOR),
      headers: headers,
      body: jsonEncode(<String, String>{
        'FirstName': firstName,
        'LastName': lastName,
        'PhoneNumber': phone,
        'EmailAddress': email,
        'CountyID': county,
        'Password': password,
        'organizationCode': organizationCode,
      }),
    );

    return Message.fromJson(json.decode(response.body));
  }

  Future<Message> createFarmProduce(
      String landAginID, String productUUID) async {
    headers['Content-Type'] = 'application/json';
    final http.Response response = await client.post(
      buildUrl(CREATE_FARM_PRODUCE),
      headers: headers,
      body: jsonEncode(<String, String>{
        'landAginID': landAginID,
        'productUUID': productUUID,
      }),
    );

    return Message.fromJson(json.decode(response.body));
  }

  Future<List<Product>> fetchProduce() async {
    headers['Content-Type'] = 'application/json';
    final response = await client.post(
      buildUrl(PRODUCT_LIST),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-AGIN-API-Key-Token': APIKEY,
      },
      body: jsonEncode(<String, String>{
        'CategoryID': "1",
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Product> listProduce = items.map<Product>((json) {
        return Product.fromJson(json);
      }).toList();
      return listProduce;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load farmers');
    }
  }

  Future<StatisticsInfo> fetchStatistics(String aggregatorAginID) async {
    final response = await client.post(
      buildUrl(AGGREGATOR_STATISTICS),
      headers: jsonHeaders,
      body: jsonEncode(<String, String>{
        'AginID': aggregatorAginID,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return StatisticsInfo.fromJson(jsonDecode(response.body));
    } else {
      Message message = Message.fromJson(jsonDecode(response.body));
    }
  }

  Future<Message> createFarm(
      String farmName,
      String farmLocation,
      String acreageMapped,
      String acreageApproved,
      String currentLandUse,
      String farmerAginId,
      double lat,
      double lon) async {
    final http.Response response = await http.post(
      buildUrl(CREATE_FARM),
      headers: jsonHeaders,
      body: jsonEncode(<String, String>{
        'farmName': farmName,
        'farmLocation': farmLocation,
        'acreageMapped': acreageMapped,
        'acreageApproved': acreageApproved,
        'currentLandUse': currentLandUse,
        'producerAginId': farmerAginId,
        'lat': lat.toString(),
        'lon': lon.toString()
      }),
    );

    return Message.fromJson(json.decode(response.body));
  }

  Future<Message> createFarmer(String firstName, String lastName, String email,
      String phone, String county, String accountManagerAginID) async {
    final http.Response response = await client.post(
      buildUrl(REGISTER_FARMER),
      headers: jsonHeaders,
      body: jsonEncode(<String, String>{
        'FirstName': firstName,
        'LastName': lastName,
        'PhoneNumber': phone,
        'EmailAddress': email,
        'AccountManagerAginID': accountManagerAginID,
        'CountyID': county
      }),
    );

    return Message.fromJson(json.decode(response.body));
  }

  Future<List<FarmerInfo>> fetchFarmers(String aggregatorAginID) async {
    final response = await client.post(
      buildUrl(FARMERS_LIST),
      headers: jsonHeaders,
      body: jsonEncode(<String, String>{
        'AginID': aggregatorAginID,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      return items
          .map<FarmerInfo>((json) => FarmerInfo.fromJson(json))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load farmers');
    }
  }

  // Future<List<FarmInfo>> fetchFarms(String farmerAginID) async {
  //   final response = await client.post(
  //     buildUrl(FARM_INFO),
  //     headers: jsonHeaders,
  //     body: jsonEncode(<String, String>{
  //       'AginID': farmerAginID,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     final items = json.decode(response.body).cast<Map<String, dynamic>>();
  //     return items.map<FarmInfo>((json) => FarmInfo.fromJson(json)).toList();
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load farmers');
  //   }
  // }

  Future<AggregatorLoginObject> loginAggregator(
      String phoneNumber, String password) async {
    var response = await client.post(
      buildUrl(AGGREGATOR_LOGIN),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-AGIN-API-Key-Token': APIKEY,
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': phoneNumber,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      AggregatorLoginObject aggregatorLoginObject =
          AggregatorLoginObject.fromJson(json.decode(response.body));

      return aggregatorLoginObject;
    } else {
      Map<String, dynamic> errorMap = {
        'status': response.statusCode,
        'message': json.decode(response.body)
      };
      throw Exception(errorMap);
    }
  }

  Future<Message> verifyAccount(String phoneNumber, String verifyCode) async {
    final http.Response response = await client.post(
      buildUrl(AGGREGATOR_LOGIN),
      headers: jsonHeaders,
      body: jsonEncode(<String, String>{
        'verifyCode': verifyCode,
        'phoneNumber': phoneNumber,
      }),
    );
    return Message.fromJson(json.decode(response.body));
  }

  Future<List<CultivationMode>> fetchCultivationModeOptions() async {
    final response = await client.get(
      buildUrl(CULTIVATION_MODES_OPTIONS),
      headers: headers,
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<CultivationMode> listDropDowns;
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      return items
          .map<CultivationMode>((json) => CultivationMode.fromJson(json))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<List<ProduceStatus>> fetchProduceStatusOptions() async {
    final response = await client.get(
      buildUrl(PRODUCT_STATUS),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      return items
          .map<ProduceStatus>((json) => ProduceStatus.fromJson(json))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<List<UnitType>> fetchUnitTypeOptions() async {
    final response = await client.get(
      buildUrl(UNIT_TYPES),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      return items.map<UnitType>((json) => UnitType.fromJson(json)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Message> createPlacetoMarket(
      String farmerAginID,
      String landAginID,
      String cultivationMode,
      String produceStatus,
      String unitType,
      String pricePerUnitType,
      String readyFromDate,
      String agronomyAginID,
      String quantityAvailable,
      String phototext,
      String fileExtension,
      String productID) async {
    final http.Response response = await client.post(
      buildUrl(ADD_PRODUCE),
      headers: jsonHeaders,
      body: jsonEncode(<String, String>{
        'farmerAginID': farmerAginID,
        'landAginID': landAginID,
        'cultivationMode': cultivationMode,
        'produceStatus': produceStatus,
        'unitType': unitType,
        'pricePerUnitType': pricePerUnitType,
        'readyFromDate': readyFromDate,
        'agronomyAginID': agronomyAginID,
        'quantityAvailable': quantityAvailable,
        'phototext': phototext,
        'fileExtension': fileExtension,
        'productID': productID,
      }),
    );
    return Message.fromJson(json.decode(response.body));
  }

  Future<List<PlaceToMarketListingInfo>> fetchPlaceToMarketListing(
      String aggregatorAginID) async {
    final response = await client.post(
      buildUrl(MARKET_PLACE_LISTING),
      headers: jsonHeaders,
      body: jsonEncode(<String, String>{
        'userAginID': aggregatorAginID,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      return items
          .map<PlaceToMarketListingInfo>(
              (json) => PlaceToMarketListingInfo.fromJson(json))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load farmers');
    }
  }

  Future<List<FarmerProduceInfo>> fetchProduceByLandAgin(
      String landAginID) async {
    final response = await client.post(
      buildUrl(GET_PRODUCE),
      headers: jsonHeaders,
      body: jsonEncode(<String, String>{
        'AginID': landAginID,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      return items
          .map<FarmerProduceInfo>((json) => FarmerProduceInfo.fromJson(json))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load farmers');
    }
  }

  Future<List<County>> _getCountiesList() async {
    List<County> conList;
    var response = await client.get(buildUrl(COUNTY_LIST), headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data.map((county) => County.fromMap(county)).toList();
    }
  }
}
