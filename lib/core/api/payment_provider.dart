import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:fimber/fimber.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../utils/constants.dart';
import '../../utils/failure.dart';

class PaymentProvider {
  Dio dio;
  PaymentProvider() {
    setupDioModule();
  }
  void setupDioModule() {
    // or new Dio with a BaseOptions instance.
    BaseOptions options = BaseOptions(
      headers: {
        "X-AGIN-API-Key-Token": APIKEY,
        // "Content-Type": 'application/json'
      },
      baseUrl: PAYMENT_BASEURL,
    );

    this.dio = Dio(options);

    //track requests and responses in development
    this.dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: false,
        ));

    this
        .dio
        .interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
          Fimber.i("REQUESTING: ${options.path}");

          return options; //continue
        }, onResponse: (Response response) async {
          // Do something with response data
          Fimber.i("RESPONSE: ${response.data}");
          return response; // continue
        }, onError: (DioError e) async {
          // Do something with response error
          switch (e.type) {
            case DioErrorType.RESPONSE:
              return e.response.data['message'];
            case DioErrorType.CANCEL:
              return "You cancelled the request";
            case DioErrorType.RECEIVE_TIMEOUT:
              return "Please try again";
            default:
              await Sentry.captureException(e.message);
              throw ApiException(e.response.statusMessage);
          }
        }));
  }

  //**************************** PAYMENT APIS ***********************************/
  Future<String> getBearer() async {
    try {
      var response = await dio.get(BEARER_TOKEN);
      if (response.statusCode == 200) {
        var headers = response.headers.map;

        print(response.headers);
        return "367457632547625647";
      }
      return Future.error("ERROR");
    } on SocketException {
      print("enable internet");
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getWalletBalance(
      String number) async {
    try {
      var token = await this.getBearer();

      dio.options.headers = {"authorization": token};
      if (token is String) {
        var response = await dio.post(WALLET_BALANCE,
            data: jsonEncode({"mpesaAccountNumber": number}));

        if (response.statusCode == 200) {
          return Right(response.data);
        } else {
          var data = response.data;
          return Left(UserFriendlyException(data['message']));
        }
      }
    } on SocketException {
      return Left(MySocketException());
    }
  }

  Future<Either<Failure, bool>> deactivateWallet(String number) async {
    try {
      var response = await dio.post(WALLET_DELETE,
          data: jsonEncode({"accountNumber": number}));
      return (response.statusCode == 200)
          ? Right(true)
          : Left(
              UserFriendlyException("Status ${response.statusCode} recieved"));
    } on SocketException {
      throw MySocketException();
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> activateWallet(
      Map options) async {
    try {
      var response = await dio.post(WALLET_REGISTER, data: jsonEncode(options));
      var data = response.data;
      return (response.statusCode == 201)
          ? Right(data)
          : Left(UserFriendlyException(data['message']));
    } on SocketException {
      return Left(MySocketException());
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> payWithMpesa(Map params) async {
    var bearer = await getBearer();
    dio.options.headers = {'Authorization': bearer};
    try {
      var response = await dio.post(MPESA_PAY, data: jsonEncode(params));

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        var data = response.data;
        return throw UserFriendlyException(data['message']);
      }
    } on SocketException {
      Left(MySocketException());
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> pushStkMpesa(Map params) async {
    var bearer = await getBearer();
    dio.options.headers = {'Authorization': bearer};
    try {
      var response = await dio.post(MPESA_PUSH_STK, data: jsonEncode(params));

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return throw UserFriendlyException(response.data['message']);
      }
    } on SocketException {
      Left(MySocketException());
    }
  }
}
