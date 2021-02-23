import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
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

  Future<Either<Failure, Map>> createFarmProduce(Map params) async {
    try {
      var response = await dio.post(
        CREATE_FARM_PRODUCE,
        data: jsonEncode(params),
      );
      if (response.statusCode == 201) {
        return Right(response.data);
      } else {
        return Left(response.data);
      }
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
        options: buildCacheOptions(Duration(days: 1)),
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
      var response = await dio.get(
        CULTIVATION_MODES_OPTIONS,
        options: buildCacheOptions(Duration(days: 14)),
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

  Future<Either<Failure, List<Map>>> fetchProduceStatusOptions() async {
    try {
      final response = await dio.get(
        PRODUCT_STATUS,
        options: buildCacheOptions(Duration(days: 14)),
      );
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
      final response = await dio.get(
        UNIT_TYPES,
        options: buildCacheOptions(Duration(days: 14)),
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

  Future<Message> createPlacetoMarket(FormData params) async {
    try {
      var response = await dio.post(
        ADD_PRODUCE,
        data: await params,
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
        options: buildCacheOptions(Duration(days: 1)),
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
        options: buildCacheOptions(Duration(days: 7)),
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
      var response = await dio.get(
        COUNTY_LIST,
        options: buildCacheOptions(Duration(days: 14)),
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

  Future<Either<Failure, List<Map>>> fetchCountries() async {
    try {
      final response = await dio.get(
        FETCH_COUNTRIES,
        options: buildCacheOptions(Duration(days: 14)),
      );

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
        throw ApiException(response.statusMessage);
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

  //upload gpx file
  Future<Either<Failure, Map>> uploadGpxFile(Map items) async {
    var formData = FormData();
    try {
      formData.fields
        ..add(MapEntry("farmerAginId", items['farmerAginID']))
        ..add(MapEntry("farmAginId", items['farmAginID']))
        ..add(MapEntry("fileType", 'gpx'));

      formData.files.add(MapEntry(
          'file',
          await MultipartFile.fromFile(items['path'],
              filename: items['fileName'])));

      var response = await dio.post('/production/farm/upload',
          data: await formData, onSendProgress: (received, total) {
        if (total != -1) {
          Fimber.i((received / total * 100).toStringAsFixed(0) + "%");
        }
      });

      if (response.statusCode == 201) {
        return Right({"message": "gpx file uploaded"});
      } else if (response.statusCode == 409) {
        return Right({"message": "File was already uploaded"});
      } else {
        return Left(ApiException(response.statusMessage));
      }
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, List<dynamic>>> getPlaceToMarketDetails() async {
    try {
      Response response = await Dio().get(BASEURL + '/market/dropdowns/list');

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(response.data);
      }
    } on SocketException {
      throw MySocketException();
    }
  }
}
