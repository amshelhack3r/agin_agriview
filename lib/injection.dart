import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/api_provider.dart';
import 'core/repository/api_repository.dart';
import 'utils/constants.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  setupDioModule();

  getIt.registerSingletonAsync(() async => ApiProvider(dio: getIt()),
      dependsOn: [Dio]);

  getIt.registerSingletonWithDependencies(() => ApiRepository(api: getIt()),
      dependsOn: [ApiProvider]);

  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerSingleton(sharedPrefs);
}

void setupDioModule() {
  // or new Dio with a BaseOptions instance.
  BaseOptions options = BaseOptions(
    headers: {
      "X-AGIN-API-Key-Token": APIKEY,
      // "Content-Type": 'application/json'
    },
    baseUrl: BASEURL,
    connectTimeout: 7000,
    receiveTimeout: 3000,
  );

  Dio dio = Dio(options);
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    compact: false,
  ));

//   dio.interceptors.add(InterceptorsWrapper(
//     onRequest:(RequestOptions options) async {
//      return options; //continue
//      },
//     onResponse:(Response response) async {
//      // Do something with response data
//      return response; // continue
//     },
//     onError: (DioError e) async {
//      // Do something with response error
//      return  e;//continue
//     }
// ));

  getIt.registerSingletonAsync(() async => dio);
}
