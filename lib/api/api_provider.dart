import 'dart:convert';
import 'dart:io';

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
import '../utils/failure.dart';

class ApiProvider {
  final client = http.Client();
  final headers = {"X-AGIN-API-Key-Token": APIKEY};
  final jsonHeaders = {
    "X-AGIN-API-Key-Token": APIKEY,
    "Content-Type": "application/json"
  };

  static buildUrl(String endpoint) => Uri.parse(BASEURL + endpoint);

  //auth apis
  Future<Message> createAggregator(Map params) async {
    headers['Content-Type'] = 'application/json';
    try {
      var response = await client.post(
        buildUrl(REGISTER_AGGREGATOR),
        headers: headers,
        body: jsonEncode(params),
      );
      if (response.statusCode == 201) {
        return Message.fromJson(json.decode(response.body));
      } else {
        final Map errorParams = {
          'status': response.statusCode,
          'message': jsonDecode(response.body)
        };
        throw ApiException(errorParams);
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<AggregatorLoginObject> loginAggregator(Map params) async {
    try {
      var response = await client.post(
        buildUrl(AGGREGATOR_LOGIN),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-AGIN-API-Key-Token': APIKEY,
        },
        body: jsonEncode(params),
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
        throw ApiException(errorMap);
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Message> verifyAccount(String phoneNumber, String verifyCode) async {
    try {
      var response = await client.post(
        buildUrl(AGGREGATOR_LOGIN),
        headers: jsonHeaders,
        body: jsonEncode(<String, String>{
          'verifyCode': verifyCode,
          'phoneNumber': phoneNumber,
        }),
      );
      return Message.fromJson(json.decode(response.body));
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Message> createFarmProduce(
      String landAginID, String productUUID) async {
    headers['Content-Type'] = 'application/json';
    try {
      var response = await client.post(
        buildUrl(CREATE_FARM_PRODUCE),
        headers: headers,
        body: jsonEncode(<String, String>{
          'landAginID': landAginID,
          'productUUID': productUUID,
        }),
      );
      return Message.fromJson(json.decode(response.body));
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<List<Product>> fetchProduce() async {
    headers['Content-Type'] = 'application/json';
    try {
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
      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        List<Product> listProduce = items.map<Product>((json) {
          return Product.fromJson(json);
        }).toList();
        return listProduce;
      } else {
        final Map errorParams = {
          'status': response.statusCode,
          'message': 'Failed to fetch produce'
        };
        throw ApiException(errorParams);
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<StatisticsInfo> fetchStatistics(String aggregatorAginID) async {
    try {
      final response = await client.post(
        buildUrl(AGGREGATOR_STATISTICS),
        headers: jsonHeaders,
        body: jsonEncode(<String, String>{
          'AginID': aggregatorAginID,
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return StatisticsInfo.fromJson(jsonDecode(response.body));
      } else {
        throw ApiException({
          'status': response.statusCode,
          'message': 'Failed to fetch Statistics'
        });
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Message> createFarm(Map params) async {
    try {
      final http.Response response = await http.post(
        buildUrl(CREATE_FARM),
        headers: jsonHeaders,
        body: jsonEncode(params),
      );
      if (response.statusCode == 201) {
        return Message.fromJson(json.decode(response.body));
      } else {
        throw ApiException(json.decode(response.body));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Message> createFarmer(Map params) async {
    try {
      final http.Response response = await client.post(
        buildUrl(REGISTER_FARMER),
        headers: jsonHeaders,
        body: jsonEncode(params),
      );
      if (response.statusCode == 201) {
        return Message.fromJson(json.decode(response.body));
      } else {
        throw ApiException({
          'status': response.statusCode,
          'message': 'Couldn\'t create farmer'
        });
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<List<FarmerInfo>> fetchFarmers(String aggregatorAginID) async {
    try {
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
        throw ApiException({
          'message': 'Failed to load farmers',
          'status': response.statusCode
        });
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<List<CultivationMode>> fetchCultivationModeOptions() async {
    try {
      var response = await client.get(
        buildUrl(CULTIVATION_MODES_OPTIONS),
        headers: headers,
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        return items
            .map<CultivationMode>((json) => CultivationMode.fromJson(json))
            .toList();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw ApiException({
          'status': response.statusCode,
          'message': 'Failed to fetch cultivation modes options'
        });
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<List<ProduceStatus>> fetchProduceStatusOptions() async {
    try {
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
        throw ApiException({
          'status': response.statusCode,
          'message': 'Failed to fetch produce status'
        });
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<List<UnitType>> fetchUnitTypeOptions() async {
    try {
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
        throw ApiException({
          'status': response.statusCode,
          'message': 'Failed to fetch produce status'
        });
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Message> createPlacetoMarket(Map params) async {
    try {
      var response = await client.post(
        buildUrl(ADD_PRODUCE),
        headers: jsonHeaders,
        body: jsonEncode(params),
      );
      return Message.fromJson(json.decode(response.body));
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<List<PlaceToMarketListingInfo>> fetchPlaceToMarketListing(
      String aggregatorAginID) async {
    try {
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
        throw ApiException({
          'status': response.statusCode,
          'message': 'Failed to fetch produce status'
        });
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<List<FarmerProduceInfo>> fetchProduceByLandAgin(
      String landAginID) async {
    try {
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
        throw ApiException({
          'status': response.statusCode,
          'message': 'Failed to fetch produce status'
        });
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<List<County>> _getCountiesList() async {
    try {
      var response = await client.get(buildUrl(COUNTY_LIST), headers: headers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data.map((county) => County.fromMap(county)).toList();
      } else {
        throw ApiException({
          'status': response.statusCode,
          'message': 'Failed to fetch produce status'
        });
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<List<Country>> fetchCountries() async {
    try {
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
        throw ApiException({
          'status': response.statusCode,
          'message': jsonDecode(response.body)
        });
      }
    } on SocketException {
      throw MySocketException();
    }
  }
}
