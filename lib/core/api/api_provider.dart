import 'dart:convert';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;

import '../../models/message.dart';
import '../../utils/constants.dart';
import '../../utils/failure.dart';

class ApiProvider {
  final client = http.Client();
  final headers = {"X-AGIN-API-Key-Token": APIKEY};
  final jsonHeaders = {
    "X-AGIN-API-Key-Token": APIKEY,
    "Content-Type": "application/json"
  };

  static buildUrl(String endpoint) => Uri.parse(BASEURL + endpoint);

  //auth apis
  Future<Either<Failure, Message>> createAggregator(Map params) async {
    headers['Content-Type'] = 'application/json';
    try {
      var response = await client.post(
        buildUrl(REGISTER_AGGREGATOR),
        headers: headers,
        body: jsonEncode(params),
      );
      if (response.statusCode == 201) {
        return Right(Message.fromJson(json.decode(response.body)));
      } else {
        final Map errorParams = {
          'status': response.statusCode,
          'message': jsonDecode(response.body)
        };
        return Left(ApiException(errorParams));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, Map>> loginAggregator(Map params) async {
    try {
      var response = await client.post(
        buildUrl(AGGREGATOR_LOGIN),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-AGIN-API-Key-Token': APIKEY,
        },
        body: jsonEncode(params),
      );
      var body = response.body;
      print(body);
      if (response.statusCode == 200) {
        return Right(json.decode(response.body));
      } else {
        return Left(ApiException(json.decode(response.body)));
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

  Future<Either<Failure, List<dynamic>>> fetchProduce() async {
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
        return Right(json.decode(response.body));
      } else {
        final Map errorParams = {
          'status': response.statusCode,
          'message': 'Failed to fetch produce'
        };
        return Left(ApiException(errorParams));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, Map>> fetchStatistics(String aggregatorAginID) async {
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
        return Right(jsonDecode(response.body));
      } else {
        Left(ApiException({
          'status': response.statusCode,
          'message': 'Failed to fetch Statistics'
        }));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<bool> createFarm(Map params) async {
    try {
      final http.Response response = await http.post(
        buildUrl(CREATE_FARM),
        headers: jsonHeaders,
        body: jsonEncode(params),
      );
      return (response.statusCode == 201)
          ? true
          : throw ApiException(json.decode(response.body));
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<int> createFarmer(Map params) async {
    try {
      final http.Response response = await client.post(
        buildUrl(REGISTER_FARMER),
        headers: jsonHeaders,
        body: jsonEncode(params),
      );
      if (response.statusCode == 201) {
        return response.statusCode;
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

  Future<Either<Failure, List<dynamic>>> fetchFarmers(
      String aggregatorAginID) async {
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
        return Right(json.decode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return Left(ApiException({
          'message': 'Failed to load farmers',
          'status': response.statusCode
        }));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, List<dynamic>>> fetchCultivationModeOptions() async {
    try {
      var response = await client.get(
        buildUrl(CULTIVATION_MODES_OPTIONS),
        headers: headers,
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Right(json.decode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return Left(ApiException({
          'status': response.statusCode,
          'message': 'Failed to fetch cultivation modes options'
        }));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, List<Map>>> fetchProduceStatusOptions() async {
    try {
      final response = await client.get(
        buildUrl(PRODUCT_STATUS),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return Right(json.decode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return Left(ApiException({
          'status': response.statusCode,
          'message': 'Failed to fetch produce status'
        }));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, List<dynamic>>> fetchUnitTypeOptions() async {
    try {
      final response = await client.get(
        buildUrl(UNIT_TYPES),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Right(json.decode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return Left(ApiException({
          'status': response.statusCode,
          'message': 'Failed to fetch unit types'
        }));
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

  Future<Either<Failure, List<Map>>> fetchPlaceToMarketListing(
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
        return Right(json.decode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return Left(ApiException({
          'status': response.statusCode,
          'message': 'Failed to fetch produce status'
        }));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<List<Map>> fetchProduceByLandAgin(String landAginID) async {
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
        return items;
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

  Future<Either<Failure, List>> fetchCounty() async {
    try {
      var response = await client.get(buildUrl(COUNTY_LIST), headers: headers);

      if (response.statusCode == 200) {
        return Right(jsonDecode(response.body));
      } else {
        return Left(ApiException({
          'status': response.statusCode,
          'message': 'Failed to fetch county status'
        }));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, List<Map>>> fetchCountries() async {
    try {
      final response =
          await client.get(buildUrl(FETCH_COUNTRIES), headers: headers);

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Right(json.decode(response.body));
      } else {
        return Left(ApiException({
          'status': response.statusCode,
          'message': jsonDecode(response.body)
        }));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, List<dynamic>>> fetchFarms(String userAginID) async {
    try {
      final response = await client.post(
        buildUrl(FARMS),
        headers: jsonHeaders,
        body: jsonEncode(<String, String>{
          'aginID': userAginID,
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Right(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return Right(List.empty());
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw ApiException({
          'status': response.statusCode,
          'message': 'Failed to fetch farm info'
        });
      }
    } on SocketException {
      throw MySocketException();
    }
  }
}
