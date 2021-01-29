import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:fimber/fimber.dart';

import '../../models/message.dart';
import '../../utils/constants.dart';
import '../../utils/failure.dart';

class ApiProvider {
  final Dio dio;

  ApiProvider({
    this.dio,
  });

  //auth apis
  Future<Either<Failure, Message>> createAggregator(Map params) async {
    dio.options.headers = {'Content-Type': 'application/json'};
    try {
      var response = await dio.post(
        REGISTER_AGGREGATOR,
        data: jsonEncode(params),
      );
      if (response.statusCode == 201) {
        return Right(Message.fromJson(response.data));
      } else {
        return Left(ApiException(response.data['message']));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, Map>> loginAggregator(Map params) async {
    try {
      var response = await dio.post(
        AGGREGATOR_LOGIN,
        data: jsonEncode(params),
      );
      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(ApiException(response.data));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Message> createFarmProduce(
      String landAginID, String productUUID) async {
    try {
      var response = await dio.post(
        CREATE_FARM_PRODUCE,
        data: jsonEncode(<String, String>{
          'landAginID': landAginID,
          'productUUID': productUUID,
        }),
      );
      return Message.fromJson(response.data);
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, List<dynamic>>> fetchProduce() async {
    try {
      final response = await dio.post(
        PRODUCT_LIST,
        data: jsonEncode(<String, String>{
          'CategoryID': "1",
        }),
      );
      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(ApiException(response.data['message']));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, Map>> fetchStatistics(String aggregatorAginID) async {
    try {
      final response = await dio.post(
        AGGREGATOR_STATISTICS,
        data: jsonEncode(<String, String>{
          'AginID': aggregatorAginID,
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Right(response.data);
      } else {
        Left(ApiException(response.data['message']));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<bool> createFarm(Map params) async {
    try {
      final response = await dio.post(
        CREATE_FARM,
        data: jsonEncode(params),
      );
      return (response.statusCode == 201)
          ? true
          : throw ApiException(response.data);
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<int> createFarmer(Map params) async {
    try {
      final response = await dio.post(
        REGISTER_FARMER,
        data: jsonEncode(params),
      );
      if (response.statusCode == 201) {
        return response.statusCode;
      } else {
        throw ApiException(response.data['message']);
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, List<dynamic>>> fetchFarmers(
      String aggregatorAginID) async {
    try {
      final response = await dio.post(
        FARMERS_LIST,
        data: jsonEncode(<String, String>{
          'AginID': aggregatorAginID,
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Right(response.data);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return Left(ApiException(response.data['message']));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, List<dynamic>>> fetchCultivationModeOptions() async {
    try {
      var response = await dio.get(CULTIVATION_MODES_OPTIONS);
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Right(response.data);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return Left(ApiException(response.data['message']));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, List<Map>>> fetchProduceStatusOptions() async {
    try {
      final response = await dio.get(PRODUCT_STATUS);
      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return Left(ApiException(response.data['message']));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, List<dynamic>>> fetchUnitTypeOptions() async {
    try {
      final response = await dio.get(UNIT_TYPES);

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Right(response.data);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return Left(ApiException(response.data['message']));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Message> createPlacetoMarket(Map params) async {
    try {
      var response = await dio.post(
        ADD_PRODUCE,
        data: jsonEncode(params),
      );
      return Message.fromJson(response.data);
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, List<Map>>> fetchPlaceToMarketListing(
      String aggregatorAginID) async {
    try {
      final response = await dio.post(
        MARKET_PLACE_LISTING,
        data: jsonEncode(<String, String>{
          'userAginID': aggregatorAginID,
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Right(response.data);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return Left(ApiException(response.data['message']));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<List<dynamic>> fetchProduceByLandAgin(String landAginID) async {
    try {
      final response = await dio.post(
        GET_PRODUCE,
        data: jsonEncode(<String, String>{
          'AginID': landAginID,
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final items = response.data.cast<Map<String, dynamic>>();
        return items;
      } else if (response.statusCode == 404) {
        return List.empty();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw ApiException(response.data['message']);
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, List<dynamic>>> fetchCounty() async {
    try {
      var response = await dio.get(COUNTY_LIST);

      if (response.statusCode == 200) {
        Fimber.d(response.data.toString());
        return Right(response.data);
      } else {
        return Left(ApiException(response.data['message']));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, List<Map>>> fetchCountries() async {
    try {
      final response = await dio.get(FETCH_COUNTRIES);

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Right(response.data);
      } else {
        return Left(ApiException(response.data['message']));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, List<dynamic>>> fetchFarms(String userAginID) async {
    try {
      final response = await dio.post(
        FARMS,
        data: jsonEncode(<String, String>{
          'aginID': userAginID,
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Right(response.data);
      } else if (response.statusCode == 404) {
        return Right(List.empty());
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw ApiException(response.data['message']);
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, List<dynamic>>> fetchProductListings(
      String productUUID) async {
    try {
      final response = await dio.post(
        PRODUCT_LISTINGS,
        data: jsonEncode(<String, String>{
          'productUUID': productUUID,
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Right(response.data);
      } else if (response.statusCode == 404) {
        return Right(List.empty());
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw ApiException(response.data['message']);
      }
    } on SocketException {
      throw MySocketException();
    }
  }
}
