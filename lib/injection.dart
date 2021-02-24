import 'package:dio/dio.dart';
import 'package:dio/src/response.dart' as Res;
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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

  //graphQl config
  await initHiveForFlutter();

  getIt.registerSingletonAsync(() async => HttpLink(GRAPHQL_URL));

  // final Link link = authLink.concat(httpLink);
  getIt.registerSingletonWithDependencies<ValueNotifier<GraphQLClient>>(
      () => ValueNotifier(
            GraphQLClient(
              link: getIt<HttpLink>(),
              cache: GraphQLCache(store: HiveStore()),
            ),
          ),
      dependsOn: [HttpLink]);
}

void setupDioModule() {
  // or new Dio with a BaseOptions instance.
  BaseOptions options = BaseOptions(
    headers: {
      "X-AGIN-API-Key-Token": APIKEY,
      // "Content-Type": 'application/json'
    },
    baseUrl: BASEURL,
  );

  Dio dio = Dio(options);

  //track requests and responses in development
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    compact: false,
  ));

  //cache all requests. this is to minimise frequent api calls
  dio.interceptors
      .add(DioCacheManager(CacheConfig(baseUrl: BASEURL)).interceptor);

  dio.interceptors
      .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
    Fimber.i("REQUESTING: ${options.path}");

    return options; //continue
  }, onResponse: (Res.Response response) async {
    // Do something with response data
    Fimber.i("RESPONSE: ${response.data}");
    return response; // continue
  }, onError: (DioError e) {
    throw e.response.data['message'];
    // return e;
  }));

  getIt.registerSingletonAsync(() async => dio);
}
